
test_that("as_int works", {

  x <- 1:4

  expect_equal(as_int(x), x)

  x1 <- c(1, 2, 3, 4)
  expect_equal(as_int(x1), x)

  x2 <- c(1, "2b", 3, "dog cat")

  expect_equal(as_int(x2), as.integer(c(1, NA, 3, NA)))
})


test_that("strip_attributes works", {

  x <- structure(5, a = "a", b = "b", class = "temp_class")

  x_check <- structure(5, class = "temp_class")

  expect_equal(strip_attributes(x), x_check)
  expect_equal(strip_attributes(x, .retain_class = FALSE), 5)

})

test_that("is_scalar_numeric works", {

  x <- list(1:4,
            letters[1:4],
            c(1, 2, 3, 4),
            "a",
            10L,
            10)

  x_check <- c(rep(FALSE, 4), rep(TRUE, 2))

  expect_equal(sapply(x, is_scalar_numeric), x_check)

})
