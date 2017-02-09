
context("SwedishPolls data")

test_that(desc="get_polls()",{
  
  # Test to download dataset
  expect_silent(dat <- get_polls())
 
  # Test of dataset structure
  expect_s3_class(dat, "tbl_df")
  checkmate::expect_names(names(dat), permutation.of = c('PublYearMonth', 'Company', 'M', 'L', 'C', 'KD', 'S', 'V', 'MP', 'SD', 'FI', 'Uncertain', 'n', 'PublDate', 'collectPeriodFrom', 'collectPeriodTo', 'approxPeriod', 'house'))
  expect_gt(nrow(dat), 1333)
  expect_equal(ncol(dat), 18)
  expect_equal(unname(unlist(lapply(dat, class))), c("character", "factor", rep("numeric", 10), "integer", rep("Date", 3), "logical", "factor"))
 
  # Test consistancy
  checkmate::expect_numeric(rowSums(dat[, 3:11], na.rm = TRUE), lower = 93.2, upper = 100)
  expect_true(all(dat$collectPeriodFrom <= dat$collectPeriodTo, na.rm = TRUE))
  expect_true(all((dat$collectPeriodTo <= dat$PublDate)[1:300], na.rm = TRUE)) # Previous data can contain errors

})


