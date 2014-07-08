Swedish polls
========================================================

This is a short description of the file Polls.csv. The file contains all polls conducted in Sweden regarding political sympathies from 2000. The file originated from [Novus](http://www.novus.se/vaeljaropinionen/ekotnovus-poll-of-polls.aspx) but has been updated and variables added.

The data is a collaboration of all interested in analyzing opinion polls. The data is open for anyone to use. The following are using this data today:
- [Botten Ada](bottenada.se)
- [pollofpolls.se](http://pollofpolls.se/poll-of-polls/)
- [trefyranio.se](http://trefyranio.com/)

This collaboration is a part of [ropengov](http://ropengov.github.io/).

### Data description

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

The value ```r NA```` follows the R standard and means missing value. 

### If you spot any faults or want to contribute...
If you spot any errors or want to contribute, fork the repository and  feel free to send me a merge request with your suggested corrections and/or additions or just drop an issue.

### To download the file direct into R
To download this file directly to R just use the following commands and you are good to go:

```r 
library(devtools)
source_gist(id = "https://gist.github.com/MansMeg/c0527fd762580006daed", quiet=TRUE)
polls <- source_GitHubData(url = "https://github.com/MansMeg/SwedishPolls/raw/master/Data/Polls.csv", sep = ",", dec = ".", header = TRUE)
```

If you just want to download the csv-file as is you can find the file [here](https://github.com/MansMeg/SwedishPolls/blob/master/Data/Polls.csv). To download it, just click "Raw".

