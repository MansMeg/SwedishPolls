[![Build Status](https://travis-ci.org/MansMeg/SwedishPolls.svg?branch=master)](https://travis-ci.org/MansMeg/SwedishPolls)

Swedish polls
========================================================

This is a short description of the file Polls.csv. The file contains all polls conducted in Sweden regarding political sympathies. The file originated from [Novus](http://www.novus.se/vaeljaropinionen/ekotnovus-poll-of-polls.aspx) but has been updated and variables added.

### Data description

The file contains the following variables.

Variable      | Description
------------- | -------------
PublYearMonth | Month and year of publication
Company	      | Company name at publication
M - Fi	      | Poll results for the different parties
Uncertain	    | Uncertain voters
n	            | The number of observations
PublDate	    | Date of publication
collectPeriodFrom	| Start date of data collection
collectPeriodTo	| End date of data collection
approxPeriod | Indicator if the period is known or if it is an approximation of the period
house | The latest companyname (if the name has been changed)

The value ```NA``` follows the R standard and means missing value. 

There are two files. ```Polls.csv``` and ```OldPolls.csv```. The file ```Polls.csv``` contains polls from 1995 - and ```OldPolls.csv``` contains data up to (and including) 1994. The same variables are used (except actual parties).

### Quality of the data
In the earlier data the quality of the data is of less good quality (more ```NA```:s in sample size and collection period). Before 2000 only Sifo is currently added. 
Data from 2008 are of better quality (ie less ```NA```). 

### If you spot any faults or want to contribute...
Just fork the repository and feel free to send me a merge request with your suggested corrections and/or additions. You can also just drop an issue in the repository.

### Thanks to
[Simon Sigurdhsson](https://github.com/urdh)

[Hampus Joakim Nilsson](https://github.com/hjnilsson)

### To use the data
If you just want to download the raw csv-file as is you can find the file [here](https://github.com/MansMeg/SwedishPolls/blob/master/Data/Polls.csv). To download it, just click "Raw".

Below there are code to read the data directly into different statistical software.

#### Using R
To download this file directly to R use the RPackage Swedish polls with the function `get_polls()`:

```r 
devtools::install_github("MansMeg/SwedishPolls")
polls <- SwedishPolls::get_polls()
```
