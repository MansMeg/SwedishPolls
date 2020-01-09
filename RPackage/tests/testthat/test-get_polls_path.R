
context("SwedishPolls paths")

test_that(desc="get_path_to_polls()",{
  checkmate::expect_file_exists(SwedishPolls:::get_path_to_polls())
})

