
context("SwedishPolls data")

test_that(desc="get_polls()",{
  
  # Test to download dataset
  expect_silent(dat <- SwedishPolls:::get_polls(as = "data_frame"))
  if(!inherits(try(SwedishPolls:::get_path_to_polls(), silent = TRUE), "try-error")){
    expect_silent(dat <- SwedishPolls:::get_polls_local(as = "data_frame"))
  } else {
    warning("main branch version of polls data is used.")
  }
  
  # Test of dataset structure
  expect_s3_class(dat, "tbl_df")
  checkmate::expect_names(names(dat), permutation.of = c('PublYearMonth', 'Company', 'M', 'L', 'C', 'KD', 'S', 'V', 'MP', 'SD', 'FI', 'Uncertain', 'n', 'PublDate', 'collectPeriodFrom', 'collectPeriodTo', 'approxPeriod', 'house'))
  expect_gt(nrow(dat), 1333)
  expect_equal(ncol(dat), 18)
  expect_equal(unname(unlist(lapply(dat, class))), c("character", "factor", rep("numeric", 10), "integer", rep("Date", 3), "logical", "factor"))
 
  # Test consistency
  incorrect_polls <- dat$PublYearMonth == "2012-jun" & dat$Company == "YouGov"
  checkmate::expect_numeric(rowSums(dat[!incorrect_polls, 3:11], na.rm = TRUE), lower = 93.2, upper = 100, info = "Parties do not sum to 93.2 < x < 100")
  checkmate::expect_numeric(rowSums(dat[1:100, 3:11], na.rm = TRUE), lower = 93.2, upper = 100, info = "Parties do not sum to 93.2 < x < 100")
  checkmate::expect_integerish(dat$n, lower = 500)
  
  expect_true(all(dat$collectPeriodFrom <= dat$collectPeriodTo, na.rm = TRUE), info = "collectPeriodFrom > dat$collectPeriodTo")
  expect_true(all((dat$collectPeriodTo <= dat$PublDate)[1:300], na.rm = TRUE), info = "dat$collectPeriodTo > dat$PublDate") # Previous data can contain errors

  # dat300 <- dat[1:300,];dat300[!(dat300$collectPeriodTo <= dat300$PublDate),]

  
  # Test specific variables
  expect_true(all(nchar(dat$PublYearMonth) == 8))
  
  # Test for duplicates
  ddat <- dat[,c("Company", "PublDate", "collectPeriodFrom", "collectPeriodTo")]
  ddat <- ddat[rowSums(is.na(ddat))==0,]
  dups <- duplicated(ddat)
  expect_true(!any(dups))
})

test_that(desc="get_polls() raw",{
  
  # Test to download dataset
  expect_silent(dat <- SwedishPolls:::get_polls("raw"))
  
  expect_true(all(!grepl(x = dat[1:50], pattern = ",,")), info = "Missing values not NA.")
  
})


test_that(desc="throw warnings",{
  
  expect_silent(dat <- SwedishPolls:::get_polls(as = "data_frame"))
  if(!inherits(try(SwedishPolls:::get_path_to_polls(), silent = TRUE), "try-error")){
    expect_silent(dat <- SwedishPolls:::get_polls_local(as = "data_frame"))
  } else {
    warning("main branch version of polls data is used.")
  }
  
  # Manually checked (and are ignored)
  ignore_column_house_PublDate <- function(column, house, PublDate){
    # V is the same for both polls
    if(column == "V" & house == "Skop" & PublDate == "2022-09-10") return(TRUE)
    # As of 2023-01-09 there are no sample size
    if(column == "n" &house == "Infostat" & PublDate == "2022-09-08") return(TRUE)
    return(FALSE)
  }
  
  # n is identical since last poll
  houses <- unique(as.character(dat[1:100,]$house))
  parties <- c("M", "L", "C", "KD", "S","V", "MP", "SD")
  for(i in seq_along(houses)){
    tmp_dat <- dat[dat$house == houses[i],]
    tmp_dat <- tmp_dat[order(tmp_dat$PublDate, decreasing = TRUE),]
    if(nrow(tmp_dat) < 2) next
    tmp_dat <- tmp_dat[1:2,]
    if(any(is.na(tmp_dat$n))) {
      if(!ignore_column_house_PublDate("n", houses[i], tmp_dat$PublDate[1])){
        stop("Polls from ", houses[i], " have missing 'n'.")
      }
    } else {
      if(tmp_dat$n[1] == tmp_dat$n[2]) stop("Last two polls from ", houses[i], " have identical 'n'.")
    }
    for(j in seq_along(parties)){
      if(ignore_column_house_PublDate(parties[j], houses[i], tmp_dat$PublDate[1])) next
      if(tmp_dat[[parties[j]]][1] == tmp_dat[[parties[j]]][2]) warning("Last two polls from ", houses[i], " have identical value for '", parties[j], "'.")
    }
  }
  
})

