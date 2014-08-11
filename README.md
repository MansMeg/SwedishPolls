Swedish polls
========================================================

This is a short description of the file Polls.csv. The file contains all polls conducted in Sweden regarding political sympathies. The file originated from [Novus](http://www.novus.se/vaeljaropinionen/ekotnovus-poll-of-polls.aspx) but has been updated and variables added.

The data is a collaboration of all interested in analyzing opinion polls. The data is open for anyone to use. The following are using this data today:
- [Botten Ada](bottenada.se)
- [pollofpolls.se](http://pollofpolls.se/poll-of-polls/)
- [trefyranio.se](http://trefyranio.com/)

This collaboration is a part of [rOpenGov](http://ropengov.github.io/).

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
In the earlier data the quality of the data is of less good quality (more ```NA```:s in sample size and collection period). Before 2000 only sifo is currently added. 
Data from 2008 are of better quality (less ```NA```). 

### If you spot any faults or want to contribute...
Just fork the repository and feel free to send me a merge request with your suggested corrections and/or additions. You can also just drop an issue in the repository.

### To use the data
If you just want to download the raw csv-file as is you can find the file [here](https://github.com/MansMeg/SwedishPolls/blob/master/Data/Polls.csv). To download it, just click "Raw".

Below there are code to read the data directly into different statistical software.

#### Using R
To download this file directly to R just use the following commands and you are good to go:

```r 
install.packages("repmis")
library(repmis)
data_url <- "https://github.com/MansMeg/SwedishPolls/raw/master/Data/Polls.csv"
polls <- repmis::source_data(data_url, sep = ",", dec = ".", header = TRUE)
```
