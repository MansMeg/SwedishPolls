context("SwedishPolls handle polls")


test_that(desc="test()",{
  
  expect_silent(dat <- SwedishPolls:::get_polls(as = "data_frame"))
  
  expect_silent(dat2 <- handle_demoskop_inizio_polls(dat))
  house_col_idx <- which(colnames(dat2) == "house")
  expect_equal(dat2[, -house_col_idx], dat[,-house_col_idx])
  expect_failure(expect_equal(dat$house, dat2$house))
  
  tab <- table(dat2$house)
  latest_date_demoskop_pre <- max(dat2$PublDate[dat2$house == "Demoskop (pre 2019-11-01)"], na.rm = TRUE)

  # expect no demoskop pre 2011, max date is okt 2019
  # expect_true(latest_date_demoskop_pre < as.Date("2019-11-01"))
  # expect_true(tab["Demoskop (pre 2019-11-01)"] == 223)

})


