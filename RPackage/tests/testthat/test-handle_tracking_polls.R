context("SwedishPolls functionality")


test_that(desc="test()",{
  
  tpfp <- testthat::test_path("test_data/test_polls.csv")
  tp <- SwedishPolls:::read_polls_csv(tpfp)

  expect_message(tpa <- handle_tracking_polls(tp, verbose = TRUE))
  expect_silent(tpb <- handle_tracking_polls(tp))
  expect_equal(tpa, tpb)
  
  tpc <- tp
  expect_silent(tpc$last <- use_last_no_overlap_indicator(tp))
  tpc <- tpc[tpc$last,]
  tpc$last <- NULL
  expect_equal(tpa, tpc)
  

  # test that the correct stuff is removed
  # rows that should be removed 
  # 0 is remove all overlapping days
  # 1 is keep if only one day is overlapping
  
  skop0 <- c(8, 11, 14, 12, 20, 22, 28, 30, 32)
  skop1 <- c(8, 11, 14, 12, 21, 22, 28, 30, 32)
  sifo0 <- c(9, 16, 19, 25, 31, 33, 34)
  sifo1 <- c(13, 19, 25, 31, 33, 36)
  novus0 <- c(40)
  novus1 <- c(40)
  ipsos0 <- c(18, 44)
  ipsos1 <- c()
  inizio0 <- c(17, 35)
  inizio1 <- c(26)
  
  rm0 <- c(skop0, sifo0, novus0, ipsos0, inizio0)
  rm1 <- c(skop1, sifo1, novus1, ipsos1, inizio1)
  
  expect_message(tp0 <- handle_tracking_polls(polls = tp, verbose = TRUE, overlap_days = 0L))
  # print(tp[rm0[order(rm0)],c("house","collectPeriodFrom", "collectPeriodTo")])
  expect_equal(tp0, tp[-rm0,])
  
  expect_message(tp1 <- handle_tracking_polls(polls = tp, verbose = TRUE, overlap_days = 1L))
  # print(tp[rm1[order(rm1)],c("house","collectPeriodFrom", "collectPeriodTo")])
  expect_equal(tp1, tp[-rm1,])  
  # tp$row_no <- 1:nrow(tp)
  # test <- tp[order(tp$house, tp$PublDate, decreasing = TRUE),c("row_no", "house","collectPeriodFrom", "collectPeriodTo")]
  # tp1[tp1$house == "Skop",c("house","collectPeriodFrom", "collectPeriodTo")]
  # x <- tp1[tp1$house == "Skop",]
  
  expect_message(tp1000 <- handle_tracking_polls(polls = tp, verbose = TRUE, overlap_days = 1000L))
  expect_equal(tp1000, tp) 
  expect_error(handle_tracking_polls(polls = tp, verbose = TRUE, overlap_days = -1))
  
})


