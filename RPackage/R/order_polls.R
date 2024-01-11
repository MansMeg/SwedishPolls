#' Order a polls tbl_df
#' 
#' @description
#' Order a polls data table by year and month
#' 
#' @param x a polls tbl_df extracted by get_polls()
#' @param decreasing logical. Should the sort order be increasing or decreasing?
#' 
#' @export
order_polls <- function(x, decreasing = TRUE){
  assert_polls(x)
  yyyymm <- publyearmonth_to_yyyymm(x = x$PublYearMonth)
  res <- as.numeric(yyyymm)+(1/1:length(yyyymm))
  x[order(res, decreasing = decreasing),]
}

publyearmonth_to_yyyymm <- function(x){
  numms <- integer(length(x))
  msswe <- months_abb_swe()
  x <- gsub(x = x, pattern = "K1", replacement = "jan")
  x <- gsub(x = x, pattern = "K2", replacement = "apr")
  x <- gsub(x = x, pattern = "K3", replacement = "jul")
  x <- gsub(x = x, pattern = "K4", replacement = "okt")
  checkmate::assert_subset(substr(x,6,8), msswe)
  
  mns <- substr(x,6,8)
  for(i in seq_along(numms)){
    numms[i] <- which(msswe%in%mns[i])
  }
  moint <- stringr::str_pad(numms, width = 2, side = "left", pad = "0")
  paste0(substr(x,1,4),moint)
}

publyearmonth_to_date <- function(x){
  x <- publyearmonth_to_yyyymm(x)
  as.Date(paste0(x, "01"), format = "%Y%m%d")
}

date_to_publyearmonth <- function(x){
  checkmate::assert_date(x)
  chrdate <- as.character(x)
  mas <- months_abb_swe()
  paste0(substr(chrdate,1,5), mas[as.integer(substr(x,6,7))])
}

