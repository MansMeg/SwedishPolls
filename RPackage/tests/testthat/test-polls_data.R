
context("SwedishPolls data")

test_that(desc="get_polls()",{
  
  # Test to download dataset
  expect_silent(dat <- get_polls_local("data_frame"))
 
  # Test of dataset structure
  expect_s3_class(dat, "tbl_df")
  checkmate::expect_names(names(dat), permutation.of = c('PublYearMonth', 'Company', 'M', 'L', 'C', 'KD', 'S', 'V', 'MP', 'SD', 'FI', 'Uncertain', 'n', 'PublDate', 'collectPeriodFrom', 'collectPeriodTo', 'approxPeriod', 'house'))
  expect_gt(nrow(dat), 1333)
  expect_equal(ncol(dat), 18)
  expect_equal(unname(unlist(lapply(dat, class))), c("character", "factor", rep("numeric", 10), "integer", rep("Date", 3), "logical", "factor"))
 
  # Test consistancy
  checkmate::expect_numeric(rowSums(dat[, 3:11], na.rm = TRUE), lower = 93.2, upper = 100, info = "Parties do not sum to 93.2 < x < 100")
  expect_true(all(dat$collectPeriodFrom <= dat$collectPeriodTo, na.rm = TRUE), info = "collectPeriodFrom > dat$collectPeriodTo")
  expect_true(all((dat$collectPeriodTo <= dat$PublDate)[1:300], na.rm = TRUE), info = "dat$collectPeriodTo > dat$PublDate") # Previous data can contain errors

})

test_that(desc="get_polls() raw",{
  
  # Test to download dataset
  expect_silent(dat <- get_polls_local("raw"))
  
  expect_true(all(!grepl(x = dat[1:50], pattern = ",,")), info = "Missing values not NA.")
  
})

cat("\n")
system("pwd")
cat("\n")