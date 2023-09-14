polls_names <- function(){
  c("PublYearMonth", "Company", "M", "L", "C", "KD", "S", "V", "MP", "SD", "FI", "Uncertain", "n", "PublDate", "collectPeriodFrom", "collectPeriodTo", "approxPeriod", "house")
}

months_abb_swe <- function(){
  c("jan", "feb", "mar", "apr", "maj", "jun", "jul", "aug", "sep", "okt", "nov", "dec")
}

assert_polls <-function(x){
  checkmate::assert_class(x, classes = "tbl_df")
  checkmate::assert_names(names(x), subset.of = polls_names())
}
