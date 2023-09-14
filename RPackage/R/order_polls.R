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
  numms <- integer(length(x$PublYearMonth))
  msswe <- months_abb_swe()
  mns <- substr(x$PublYearMonth,6,8)
  for(i in seq_along(numms)){
    numms[i] <- which(msswe%in%mns[i])
  }
  moint <- stringr::str_pad(numms, width = 2, side = "left", pad = "0")
  res <- as.numeric(paste0(substr(x$PublYearMonth,1,4),moint))+(1/1:length(moint))
  x[order(res, decreasing = decreasing),]
}