#' Get the Swedish Polls dataset
#'
#' @description 
#' Download and read in the polls dataset in R as a \code{tibble}.
#'
#' @param as How to get polls (raw or as parsed data_frame).
#' 
#' @export
get_polls <-function(as = "data_frame"){
  checkmate::assert_choice(as, c("data_frame", "raw"))
  # Create file path
  file_tmp_path <- paste0(tempdir(), "/polls.csv")
  file_to_dl <- "https://raw.githubusercontent.com/MansMeg/SwedishPolls/master/Data/Polls.csv"   
  
  # Assert access to source
  stopifnot(!httr::http_error(file_to_dl))
    
  # Download file
  utils::download.file(file_to_dl, destfile = file_tmp_path, method = "curl", quiet = TRUE)

  if(as == "data_frame"){
    res <- read_polls_csv(file_tmp_path)
  } else if (as == "raw") {
    res <- readLines(file_tmp_path)    
  }
  
  res
}

#' @rdname get_polls
#' @param as How to get polls (raw or as parsed data_frame).
#' @keywords Internal
get_polls_local <-function(as){
  checkmate::assert_choice(as, c("data_frame", "raw"))

  file_tmp_path <- get_path_to_polls()
  
  if(as == "data_frame"){
    res <- read_polls_csv(file_tmp_path)
  } else if (as == "raw") {
    res <- readLines(file_tmp_path)    
  }
  res
}

#' Compute path to Polls files
#' 
#' @keywords Internal
get_path_to_polls <- function(){
  wd_path <- strsplit(getwd(), "/")[[1]]
  depth <- length(wd_path)
  while(!checkmate::test_file_exists(paste(c(wd_path[1:depth], "Data", "Polls.csv"), collapse = "/"))){
    depth <- depth - 1L
    if(depth == 0) stop("Polls.csv not found!")
  }
  path <- paste(c(wd_path[1:depth], "Data", "Polls.csv"), collapse = "/")
  path
}

#' @rdname get_polls
#' @param path Local path to Polls.csv
#' @keywords Internal
read_polls_csv <- function(path){
  df <- utils::read.csv(path, stringsAsFactors = FALSE)
  as_polls(df)
}

#' Convert a table to a polls tbl_df
#' @param x an object to convert
#' @export
as_polls <- function(x){
  checkmate::assert_names(names(x), must.include = c("Company", "PublDate", "collectPeriodFrom", "collectPeriodTo", "house"))
  x$Company <- factor(x$Company)
  x$PublDate <- lubridate::ymd(x$PublDate)
  x$collectPeriodFrom <- lubridate::ymd(x$collectPeriodFrom)
  x$collectPeriodTo <- lubridate::ymd(x$collectPeriodTo)
  x$house <- factor(x$house)
  x <- dplyr::as_tibble(x)
  assert_polls(x)
  x
}


