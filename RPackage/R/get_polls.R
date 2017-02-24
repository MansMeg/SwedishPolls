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

  read_polls_csv(file_tmp_path)
}

#' @rdname get_polls
#' @param as How to get polls (raw or as parsed data_frame).
#' @keywords Internal
get_polls_local <-function(as){
  checkmate::assert_choice(as, c("data_frame", "raw"))
  file_tmp_path <- "../../../Data/Polls.csv"
  if(as == "data_frame"){
    res <- read_polls_csv(file_tmp_path)
  } else if (as == "raw") {
    res <- readLines(file_tmp_path)    
  }
}

#' @rdname get_polls
#' @param path Local path to Polls.csv
#' @keywords Internal
read_polls_csv <- function(path){
  df <- utils::read.csv(path, stringsAsFactors = FALSE)
  df$Company <- factor(df$Company)
  df$PublDate <- lubridate::ymd(df$PublDate)
  df$collectPeriodFrom <- lubridate::ymd(df$collectPeriodFrom)
  df$collectPeriodTo <- lubridate::ymd(df$collectPeriodTo)
  df$house <- factor(df$house)
  dplyr::as_data_frame(df)
}