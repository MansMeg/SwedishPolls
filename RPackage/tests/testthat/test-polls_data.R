
context("SwedishPolls data")

test_that(desc="get_polls()",{
  
  # Test to download dataset
  expect_silent(dat <- SwedishPolls:::get_polls(as = "data_frame"))
  expect_silent(dat <- SwedishPolls:::get_polls_local(as = "data_frame"))
  
  
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

cat("\n")
system("pwd")
cat("\n")