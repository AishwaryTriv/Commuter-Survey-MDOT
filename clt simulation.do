*** author: aishwary trivedi
*** objective: central limit theorem using -simulate-

* prelim 
clear all 
set more off 
set seed 10101

* define a program that calculates mean of 30 random numbers draw from 
* an uniform distribution. 
capture program drop samplemean
program define samplemean, rclass 
	* drop all variables and start with an empty dataset
	cap drop _all
	* change the number of observations. in this example, we will see how 
	* simply drawing from as small a sample as 30 obs will demonstrate CLT
	set obs 30 
	* draw random numbers from any distribution: runiform, rbinomial etc. 
	* note: population distribution does not have to be -rnormal-
	gen x = runiform(70, 900)
	* summarize x to get the mean
	sum x 
	* save the mean to a scalar
	return scalar smean = `r(mean)'
end 

* test if the program is working
samplemean 

* conduct 5,000 simulations 
simulate xbar=r(smean), reps(5000): samplemean

* what is the distribution of the sample means?
hist xbar 

* lo and behold, even though the population distribution was not normal, 
* the sample means are distributed normally 
