<!-- badges: start -->
![R](https://github.com/MansMeg/SwedishPolls/actions/workflows/r.yml/badge.svg)
[![Codecov test coverage](https://codecov.io/gh/MansMeg/SwedishPolls/branch/master/graph/badge.svg)](https://app.codecov.io/gh/MansMeg/SwedishPolls?branch=master)
<!-- badges: end -->

Swedish polls
========================================================

This README is a short description of the file Polls.csv and the RPackage to handle these polls. The file Polls.csv contains all polls conducted in Sweden regarding political sympathies. The file originated from [Novus](http://www.novus.se/vaeljaropinionen/ekotnovus-poll-of-polls.aspx) in 2013 but has been updated, and variables has been added since then.

### Data description

The file contains the following variables.

Variable      | Description
------------- | -------------
PublYearMonth | Month and year of publication
Company	      | Company name at publication
M - Fi	      | Poll results for the different parties
Uncertain	    | Uncertain voters
n	            | The number of observations (see below)
PublDate	    | Date of publication
collectPeriodFrom	| Start date of data collection
collectPeriodTo	| End date of data collection
approxPeriod | Indicator if the period is known or if it is an approximation of the period
house | The latest company name (if the name has been changed)

The value ```NA``` follows the R standard and means missing value. 

#### Definitions of the number of observations
Some polling institutes report the total sample size and the number of respondents. Here we use the number of actual respondents in the poll as the sample size.

### Quality of the data
In the earlier data, the quality of the data is of less good quality (more ```NA```:s in sample size and collection period). Before 2000 only Sifo is currently added. 
Data from 2008 are of better quality (i.e. less ```NA```). 

#### Issue with Ipsos
The house Ipsos round their numbers from the mid-2010s. Sometimes these numbers sum up to 101. In these situations, the numbers have been normalized by multiplying the values by 100/101. To get the original values, round up the Ipsos values to the closest integer.

#### Issue with Sentio
Sentio usually reports two numbers, total respondents and party preferences. Here we use the number of party preferences, but other definitions might have been used in older data.

### If you spot any faults or want to contribute...
Just fork the repository and feel free to send me a merge request with your suggested corrections and/or additions. You can also drop an issue in the repository.


## Thanks to
[Simon Sigurdhsson](https://github.com/urdh)

[Hampus Joakim Nilsson](https://github.com/hjnilsson)

### To use the data
If you want to download the raw CSV file, you can find the file [here](https://github.com/MansMeg/SwedishPolls/blob/master/Data/Polls.csv). To download it, click "Raw".

Below there are codes to read the data directly into different statistical software.

#### Using R
To download this file directly to R use the RPackage Swedish polls with the function `get_polls()`:

```r 
devtools::install_github("MansMeg/SwedishPolls", subdir = "RPackage")
polls <- SwedishPolls::get_polls()
```

Using R, it is also simple to get data for the last elections in the same format as the polls.

```r 
data("elections", package = "SwedishPolls")
```

We can handle tracking polls (polls with overlapping collection periods, usually close to elections) with the following R function. This function returns the latest, non-overlapping tracking polls. 

```r 
new_polls <- handle_tracking_polls(polls)
```

In 2019, Inizio and Demoskop merged, and from this point, the polls of Inizio were used by Demoskop. The following function creates a new house variable for Inizio and Demoskop based on the actual method used.

```r 
new_polls <- handle_demoskop_inizio_polls(polls)
```


