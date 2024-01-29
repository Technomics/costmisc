
test_that("paste_difftime works", {

  x <- as.POSIXct("2020-06-29 11:00:00 EDT")
  y <- as.POSIXct("2020-06-29 11:14:48 EDT")

  testthat::expect_output(print(paste_difftime(y - x), digits = 7),
                          "Time difference of 14.8 mins")

  testthat::expect_output(print(paste_difftime(y - x, "My message", 1)),
                          "My message 15 mins")
})
