
context("SwedishPolls data")

test_that(desc="get_polls()",{
  x <- c("2018-aug","1973-okt", "1973-aug", "1973-jun", "1973-maj", "1973-apr", "1973-mar", "1973-feb", "1973-jan", "1972-dec", "1972-nov", "1972-okt", "1972-sep")
  x2 <- expect_silent(publyearmonth_to_date(x))
  x3 <- expect_silent(date_to_publyearmonth(x2))
  expect_equal(x,x3)
})

