*** author: aihwary  trivedi
*** objective: generating random variables from various types of distributions


*************************************************
*  binomial distribution
*************************************************

*** drawing random numbers

clear all 
set obs 1000
set seed 379
gen z = rbinomial(10, 0.2)
hist z, discrete // plot random variable 

*************************************************
*  uniform distribution
*************************************************

*** drawing random numbers
					 
clear all 
set obs 1000
set seed 87
gen y = runiform(0, 7)
hist y // plot random variable 

*************************************************
*  normal distribution
*************************************************

*** drawing random numbers
					 
clear all 
set obs 1000
set seed 980
gen w = rnormal(0, 1)
hist w // plot random variable
