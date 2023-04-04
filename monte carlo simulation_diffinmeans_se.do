*** author: aishwary trivedi
*** objective: conduct monte carlo simulations to estimate the 
*** standard error of the difference-in-means estimator

* prelim 
clear all
set more off
set seed 123456

*** step 1: create 1000 obs with potential outcomes

* set obs 
set obs 100

* define id variable 
gen id = _n 

* generate potential outcome, under treatment and control 

* assume, control outcomes drawn from distribution have mu=0, sigma=1
gen Y0 = rnormal(0, 1)

* assume, treatment outcomes drawn from distribution with mu=1, sigma=1
gen Y1 = rnormal(1, 1)

* what is the true standard deviation of the difference in means estimator?
scalar stddev = sqrt(1/50 + 1/50)

*** step 2: simulate 5k hypothetical RCTs by randomly assigning 
*** units to treatment and control and calculate mean and std error
*** of the difference-in-means estimator

capture program drop ate_sim_se
program define ate_sim_se, rclass 
	* first, define randomnumber variable 
	cap drop randomnumber
	generate randomnumber = runiform()
	* then, sort by randomnumber 
	sort randomnumber 
	* next, define treatment/control 
	cap drop treatment 
	generate treatment = cond(_n <= _N/2, 1, 0)
	* calculate mean and variance in control group 
	sum Y0 if treatment == 0
	scalar mu0 = `r(mean)'
	scalar var0 = `r(Var)'
	* calculate mean and variance in treatment group 
	sum Y1 if treatment == 1
	scalar mu1 = `r(mean)'
	scalar var1 = `r(Var)'
	* now use -return- to save the estimates of interest so that they 
	* are available when we type -return list- after the program
	* difference in means i.e. the sample average treatment effect 
	return scalar diffmeans = mu1 - mu0 
	* standard error of the diff in means estimator
	return scalar stderr = sqrt(var0/50 + var1/50)
end 

* conduct 5,000 simulations and save the returned locals as variables 
simulate diffinmeans_est = r(diffmeans) diffinmeans_se = r(stderr), ///
reps(5000): ate_sim_se

* summarize the std err
sum diffinmeans_se 

* compare with the true std dev 
di "Difference b/w true SD and estimated SE is: " `r(mean)' - stddev 
 
