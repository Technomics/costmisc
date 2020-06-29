
test_that("clean by", {
  by1 <- c("a", "b")
  by2 <- c(a = "a", b = "b")
  by3 <- c(a1 = "a", "b")
  by4 <- c(a1 = "a", b1 = "b")

  by5 <- clean_by(by1)

  by12_check <- list(x = c("a", "b"),
                    y = c("a", "b"))

  by3_check <- list(x = c("a1", "b"),
                    y = c("a", "b"))

  by4_check <- list(x = c("a1", "b1"),
                    y = c("a", "b"))

  expect_equal(clean_by(by1), by12_check)
  expect_equal(clean_by(by2), by12_check)
  expect_equal(clean_by(by3), by3_check)
  expect_equal(clean_by(by4), by4_check)
  expect_equal(clean_by(by5), by12_check)

})
