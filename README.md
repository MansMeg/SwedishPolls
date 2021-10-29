![R](https://github.com/MansMeg/SwedishPolls/actions/workflows/r.yml/badge.svg)

Swedish polls
========================================================

This is a short description of the file Polls.csv. The file contains all polls conducted in Sweden regarding political sympathies. The file originated from [Novus](http://www.novus.se/vaeljaropinionen/ekotnovus-poll-of-polls.aspx) in 2013 but has been updated and variables has been added since then.

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
house | The latest companyname (if the name has been changed)

The value ```NA``` follows the R standard and means missing value. 

#### Definitions of the number of observations
Some polling institutes report both the total sample size and the number of respondents. Here we use the number of actual respondents as the sample size.

### Quality of the data
In the earlier data the quality of the data is of less good quality (more ```NA```:s in sample size and collection period). Before 2000 only Sifo is currently added. 
Data from 2008 are of better quality (ie less ```NA```). 

#### Issue with Ipsos
The house Ipsos round their numbers from the mid 2010s. Sometime these numbers sum up to 101. In these situations, the numbers has been normalized by multiplying the values with 100/101. To get the original values, just round up the Ipsos values to the closest integer.

#### Issue with Sentio
Sentio usually reports two numbers, total respondents and party preferences. Here we use the number of party preferences, but in older data other definitions might have been used.

### If you spot any faults or want to contribute...
Just fork the repository and feel free to send me a merge request with your suggested corrections and/or additions. You can also just drop an issue in the repository.


## Thanks to
[Simon Sigurdhsson](https://github.com/urdh)

[Hampus Joakim Nilsson](https://github.com/hjnilsson)

### To use the data
If you just want to download the raw csv-file as is you can find the file [here](https://github.com/MansMeg/SwedishPolls/blob/master/Data/Polls.csv). To download it, just click "Raw".

Below there are code to read the data directly into different statistical software.

#### Using R
To download this file directly to R use the RPackage Swedish polls with the function `get_polls()`:

```r 
devtools::install_github("MansMeg/SwedishPolls", subdir = "RPackage")
polls <- SwedishPolls::get_polls()
```

Using R it is allso simple to get data for the last elections in the same format as the polls.

```r 
data("elections", package = "SwedishPolls")
```