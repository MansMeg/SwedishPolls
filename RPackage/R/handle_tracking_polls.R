#' Handle tracking polls
#'
#' @details 
#' Some polls overlap in time, especially close to an election. These polls
#' are usually a way for a house to track parties leading up to an election.
#' Although, they are commonly using the same observations multiple times
#' which might introduce problem when using the polls in a model. Hence,
#' this function helps handling these tracking polls.
#' 
#' @param polls a polls \code{data.frame}
#' @param correction what correction to use. 
#' See \code{supported_tracking_polls_corrections()} for details on what
#' corrections that can be used.
#' @param verbose should information on the handling be printed as messages? Defaults to \code{FALSE}. 
#' @param ... further arguments supplied to the tracking polls correction function(s).
#' 
#' @export
handle_tracking_polls <- function(polls = NULL, correction = "use_last_no_overlap", verbose = FALSE, overlap_days = 1L, ...){
  if(is.null(polls)){
    polls <- get_polls()
  }
  assert_polls(polls)
  checkmate::assert_choice(correction, supported_tracking_polls_corrections())
  
  # Add order
  polls$row_number <- 1:nrow(polls)
  
  # Iterate over houses
  results <- list()
  houses <- as.character(unique(polls$house))
  for(i in seq_along(houses)){
    ph <- polls[polls$house == houses[i],]
    if(nrow(ph) > 1){
      cnms <- colnames(ph)
      ph <- add_tracking_poll_info(ph, overlap_days = overlap_days)
      ph <- use_last_no_overlap(ph, overlap_days = overlap_days)[, c(cnms, "last_no_overlap")]    
    } else {
      ph$last_no_overlap <- TRUE
    }
    results[[i]] <- ph
  }
  results <- do.call(args = results, rbind)
  
  results <- results[order(results$row_number),]
  if(verbose){
    removed <- results[!results$last_no_overlap, ]
    message(paste0("Removed overlapping polls (total: ", nrow(removed),")\n"))
    message(short_poll_info(removed$house, removed$collectPeriodFrom, removed$collectPeriodTo))
  }
  # Finalize
  results <- results[results$last_no_overlap,]
  
  results$last_no_overlap <- NULL
  results$row_number <- NULL
  rownames(results) <- NULL
  results  
}


short_poll_info <- function(house, from, to){
  paste0(house, " (", from, "--", to, ")\n")
}

#' Implemented corrections for tracking polls
#' 
#' @export
supported_tracking_polls_corrections <- function(){
  c("use_last_no_overlap")
}


#' Use the last poll without overlap with previous polls
#'
#' @param x a polls \code{data.frame}
#' @param overlap_days the number of days that can overlap between polls without consider it an overlap. 
#' 
use_last_no_overlap <- function(x, overlap_days){
  checkmate::assert_data_frame(x)
  checkmate::assert_names(names(x), must.include = c("collectPeriodFrom", "collectPeriodTo", "tracking_poll_n", "tracking_poll_no", "house"))
  # Assert that only 1 house is used
  checkmate::assert_true(length(unique(x$house)) == 1L)
  checkmate::assert_date(x$collectPeriodTo)
  checkmate::assert_date(x$collectPeriodFrom)
  checkmate::assert_integerish(overlap_days, len = 1, lower = 0)
  
  
  # Store order and sort
  x$row_order <- 1:nrow(x)
  x <- x[order(x$collectPeriodTo, decreasing = TRUE),]
  
  x$last_no_overlap <- x$tracking_poll_no == x$tracking_poll_n 
  x$tracking_poll[is.na(x$tracking_poll)] <- FALSE
  
  # Fix remaining tracking polls
  for(i in 1:nrow(x)){
    if(!x$tracking_poll[i]) next
    if(x$last_no_overlap[i]) {
      last_idx <- i
      next
    }
    if(x$collectPeriodFrom[last_idx] + overlap_days > x$collectPeriodTo[i]){
      x$last_no_overlap[i] <- TRUE
      last_idx <- i
    }
  }
  
  # Finalize
  x <- x[x$row_order,]
  x$row_order <- NULL
  x
}

#' Add information on tracking polls
#' 
#' @param x a polls \code{data.frame} with \code{collectPeriodTo} and \code{collectPeriodFrom}.
#' @param overlap_days the number of days that can overlap between polls without consider it an overlap. 
#' Defaults to 1L.
#' 
#' @details 
#' Identifies tracking polls (polls with overlapping collection periods)
#' 
#' @return 
#' \code{overlap_previous_poll}: the poll overlaps with previous polls
#' \code{tracking_poll}: the poll part of a tracking poll
#' \code{tracking_poll_id}: id variable for tracking and ordinary polls
#' \code{tracking_poll_n}: the number of polls part of the tracking poll
#' \code{tracking_poll_no}: the tracking poll number
#' 
#' @export
add_tracking_poll_info <- function(x, overlap_days = 1L){
  checkmate::assert_data_frame(x, min.rows = 2)
  checkmate::assert_names(names(x), must.include = c("collectPeriodTo", "collectPeriodFrom"))
  # Assert that only 1 house is used
  checkmate::assert_true(length(unique(x$house)) == 1L)
  checkmate::assert_date(x$collectPeriodTo)
  checkmate::assert_date(x$collectPeriodFrom)
  checkmate::assert_integerish(overlap_days, len = 1, lower = 0)
  
  # Store order
  x$row_order <- 1:nrow(x)
  
  # Order by last date
  x <- x[order(x$collectPeriodTo, decreasing = TRUE),]
  
  # Look for overlap 
  x$overlap_previous_poll <- c(x$collectPeriodTo[-1] >= x$collectPeriodFrom[-length(x$collectPeriodFrom)] + overlap_days, FALSE)
  x$tracking_poll <- x$overlap_previous_poll
  for(i in 2:nrow(x)){
    if(is.na(x$overlap_previous_poll[i]) | is.na(x$overlap_previous_poll[i-1])) next
    if(!x$overlap_previous_poll[i] & x$overlap_previous_poll[i-1]){
      x$tracking_poll[i] <- TRUE
    }
  }
  
  # Add tracking poll_id
  x$tracking_poll_id <- 1L
  for(i in (nrow(x)-1):1){
    if(is.na(x$overlap_previous_poll[i]) | is.na(x$overlap_previous_poll[i+1])) {
      x$tracking_poll_id[i] <- x$tracking_poll_id[i+1] + 1L
      next
    }
    if(!x$overlap_previous_poll[i]) {
      x$tracking_poll_id[i] <- x$tracking_poll_id[i+1] + 1L
    } else {
      x$tracking_poll_id[i] <- x$tracking_poll_id[i+1]
    }
  }
  

  # Add tracking_poll_n
  tpdf <- as.data.frame(table(x$tracking_poll_id))
  colnames(tpdf) <- c("tracking_poll_id", "tracking_poll_n")
  tpdf$tracking_poll_id <- as.integer(as.character(tpdf$tracking_poll_id))
  nms <- colnames(x)
  x <- merge(x, tpdf) 
  x <- x[,c(nms, "tracking_poll_n")]
  x <- x[order(x$collectPeriodTo, decreasing = TRUE),]

  # Add tracking_poll_no
  x$tracking_poll_no <- 1L
  for(i in (nrow(x)-1L):1){
    if(x$tracking_poll_id[i] == x$tracking_poll_id[i+1]){
      x$tracking_poll_no[i] <- x$tracking_poll_no[i+1] + 1L
    }
  }
  
  # Finalize
  x <- x[x$row_order,]
  x$row_order <- NULL
  x
}


assert_polls <- function(x){
  checkmate::assert_data_frame(x)
  checkmate::assert_names(names(x), must.include = c("PublYearMonth","Company","M","L","C","KD","S","V","MP","SD","FI","Uncertain","n","PublDate","collectPeriodFrom","collectPeriodTo","approxPeriod","house"))
  checkmate::assert_date(x$collectPeriodFrom)
  checkmate::assert_date(x$collectPeriodTo)
  
}
