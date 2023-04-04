*author:  aishwary trivedi
*objective: RANDOM WALK


// Simulate random walk
clear all
set obs 100
gen t=_n
tsset t
gen p =.
replace p=0 if t ==1
forvalues i =2/100{
	replace p = p[_n-1] + rnormal(0,1) if t==`i'
}

// Take first differences
gen diff_p = p - L1.p

// Calculate autocorrelations
ac diff_p, lags(10)

*regression

reg p L1.p

/*The coefficient on L1.p represents the persistence of the random walk, or the 
extent to which current values are related to past values. Since the coefficient 
is 0.912 which is close to 1 and p value is close to 0 so  the random walk is
highly persistent.*/

save "/Users/aishwarytrivedi/Downloads/ECON PSet 2 random walk data.dta"


// Download data
import delimited "/Users/aishwarytrivedi/Downloads/HistoricalPrices.csv", clear 
encode date, generate(dates)
tsset dates
gen diff_close = close - L1.close
regress close L1.close

// Test for serial correlation
estat dwatson

/*The Durbin-Watson statistic tests for serial correlation in the residuals of a regression.
Since the statistic is 2.228 which is more than 2, then there is negative serial correlation.*/


// Download data
import delimited "/Users/aishwarytrivedi/Downloads/HistoricalPrices (1).csv", clear 
encode date, generate(dates)
tsset dates
gen diff_close = close - L1.close
regress close L1.close

// Test for serial correlation
estat dwatson

/*The Durbin-Watson statistic tests for serial correlation in the residuals of a regression.
Since the statistic is 2.06 which is close to 2, then there is no serial correlation.*/

