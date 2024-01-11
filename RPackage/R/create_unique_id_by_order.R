#' Create a unique id per poll 
#' 
#' @description
#' The function create a unique ID per poll based on the columns chosen.
#' If there are multiple polls with the given IDs, the IDs are added with the 
#' order and total polls in \code{x}.
#' 
#' @param x a polls data.frame
#' @param use_columns which columns should be used to create the unique ID
#' 
#' 
create_unique_id_by_order <- function(x, use_colnames = c("PublYearMonth", "Company")){
  assert_polls(x)
  checkmate::assert_data_frame(x)
  checkmate::assert_names(names(x), must.include = use_colnames)
  x <- x[, use_colnames]
  x$row <- 1:nrow(x)
  x$tmp_id <- apply(x[, use_colnames], 1 , paste0 , collapse = "-" )
  
  x <- x[order(x$tmp_id, x$row),]
  dupl <- as.integer(duplicated(x[,use_colnames], fromLast = TRUE))
  
  no <- rep(1L, length(dupl))
  has_multiple_polls <- rep(FALSE, length(dupl))
  for(i in (length(dupl)-1L):1){
    if(dupl[i] > 0) {
      no[i] <- no[i+1] + 1L
      has_multiple_polls[i] <- has_multiple_polls[i+1] <- TRUE
    }
    
  }
  
  tab <- table(x$tmp_id)
  tmpdf <- data.frame(tmp_id = names(tab), total = as.vector(tab))
  x <- merge(x, tmpdf)
  
  x$no <- as.character(no)  
  x$id <- apply(x[,c(use_colnames, "no", "total")], 1 , paste , collapse = "-" )
  x$id[!has_multiple_polls] <- x$tmp_id[!has_multiple_polls]
  x[order(x$row),]$id
}