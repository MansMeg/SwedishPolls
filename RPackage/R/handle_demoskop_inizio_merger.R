#' Handle Demoskop Inizio merger
#' 
#' @details 
#' In 2019 Demoskop and Inizio merged. This had the effect that the former
#' Inizio poll was being use as the Demoskop poll.
#' 
#' This function set the house of the Inizio polls to \code{Demoskop} and the previous
#' Demoskop polls to house \code{Demoskop (pre 2019-11-01)}.
#' 
#' Details can be seen in the Aftonbladet polls:
#' \url{https://www.aftonbladet.se/nyheter/samhalle/a/e8mweR/rekordhogt-stod-for-sd--knappar-in-pa-s}
#' \url{https://www.expressen.se/nyheter/historisk-matning-s-och-sd-jamnstora-for-forsta-gangen/}
#' \url{https://www.aftonbladet.se/nyheter/samhalle/a/e8Rp6g/historisk-matning-nu-ar-sd-storst-i-sverige}
#' 
#' Details on ther merger can be found here.
#' \url{https://demoskop.se/news/demoskop-och-inizio-gar-samman-skapar-nytt-ledande-analysforetag/}
#' 
#' @param polls a polls \code{data.frame}. Default (NULL) access the lastest dataset.
#' 
#' @export
handle_demoskop_inizio_polls <- function(polls = NULL){
  if(is.null(polls)){
    polls <- get_polls()
  }
  assert_polls(polls)
  polls$house <- as.character(polls$house)
  polls_before_start_idx <- min(which(polls$PublDate < as.Date("2019-11-01")))
  polls$house[polls$house == "Demoskop" & 1:nrow(polls) >= polls_before_start_idx] <- "Demoskop (pre 2019-11-01)"
  polls$house[polls$house == "Inizio"] <- "Demoskop"
  polls$house <- as.factor(polls$house)
  assert_polls(polls)
  polls
}
