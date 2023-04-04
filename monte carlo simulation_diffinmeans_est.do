*** author: aishwary trivedi
*** objective: conduct monte carlo simulations to test whether
*** the difference-in-means estimator is unbiased

* prelim 
clear all
set more off
set seed 123456

*** step 1: create 100 obs with potential outcomes

* set obs 
set obs 100

* define id variable 
gen id = _n 

* assume, random variables generated in control have mu=0, sigma=1
gen Y0 = rnormal(0, 1)

* assume, random variables generated in treatment have mu=1, sigma=1
gen Y1 = rnormal(1, 1)

* define individual treatment effect 
gen tau = Y1 - Y0 

* summarize the true value of the difference
summarize tau, meanonly
scalar ate = `r(mean)'
di ate 

*** step 2: simulate 5k hypothetical RCTs by randomly assigning 
*** units to treatment and control and calculate mean of the 
*** difference-in-means estimator

capture program drop ate_sim
program define ate_sim, rclass 
	*** assign obs to treatment and control by generating a random number
	*** and then sorting by the random number
	* first, define randomnumber variable 
	cap drop randomnumber
	generate randomnumber = runiform()
	* then, sort by randomnumber 
	sort randomnumber 
	* next, define treatment/control 
	cap drop treatment 
	generate treatment = cond(_n <= _N/2, 1, 0)
	* calculate mean in control group 
	sum Y0 if treatment == 0
	scalar mu0 = `r(mean)'
	* calculate mean in treatment group 
	sum Y1 if treatment == 1
	scalar mu1 = `r(mean)'
	* now use -return- to save the estimates of interest so that they 
	* are available when we type -return list- after the program
	* difference in means i.e. the sample average treatment effect 
	return scalar diffmeans = mu1 - mu0 
	* estimation error
	return scalar esterr = mu1 - mu0 - ate
end 

* conduct 5,000 simulations and save the returned locals as variables 
simulate error_est = r(esterr) diffinmeans_est = r(diffmeans), ///
reps(5000): ate_sim

* summarize the mean and compare it with the ate
* we observe that the mean of the estimator is close to the ATE
di ate  
sum diffinmeans_est 

* plot histogram of the the difference-in-means estimator
tw hist diffmeans, fc(none) xline(1.0560941, lc(red)) xline(`r(mean)', lc(black))

* altenatively, we can look at the mean of the estimated error
* for an unbiased estimator, the mean should be zero
sum error_est

* what is the standard error of the estimator? 
* estimator is on average 0.164 points away from the true value 
sum diffinmeans_est
