#' Get the Swedish Polls dataset
#'
#' @description 
#' Download and read in the polls dataset in R as a \code{tibble}.
#'
#' @export
get_polls <-function(){
  # Create file path
  file_tmp_path <- paste0(tempdir(), "/polls.csv")
  
  file_to_dl <- "https://raw.githubusercontent.com/MansMeg/SwedishPolls/master/Data/Polls.csv"   
  
  # Assert access to source
  stopifnot(!httr::http_error(file_to_dl))
    
  # Download file
  utils::download.file(file_to_dl, destfile = file_tmp_path, method = "curl", quiet = TRUE)

  df <- utils::read.csv(file_tmp_path, stringsAsFactors = FALSE)
  df$Company <- factor(df$Company)
  df$PublDate <- lubridate::ymd(df$PublDate)
  df$collectPeriodFrom <- lubridate::ymd(df$collectPeriodFrom)
  df$collectPeriodTo <- lubridate::ymd(df$collectPeriodTo)
  df$house <- factor(df$house)
  dplyr::as_data_frame(df)
}