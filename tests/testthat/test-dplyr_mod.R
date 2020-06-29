
test_that("insensitive distinct", {

  df <- data.frame(x = c("A", "B", "C", "a", "aa", "b", "cat"),
                   y = c(1, 2, 3, 1, 5, 6, 7),
                   z = c("x", "xx", "yy", "X", "Z", "z", "xyz"),
                   stringsAsFactors = FALSE)

  df_check <- df[-4, ]
  rownames(df_check) <- NULL

  df_check2 <- data.frame(x = c("A", "B", "C", "aa", "cat"),
                          stringsAsFactors = FALSE)

  expect_equal(distinct_insensitive(df), df_check)
  expect_equal(distinct_insensitive(df, "x"), df_check2)
  expect_equal(distinct_insensitive(df, "x", "z", .keep_all = TRUE), df_check)
})

test_that("insensitive joins", {

  df1 <- data.frame(x = c("A", "B", "C"),
                    y = 1:3,
                    stringsAsFactors = FALSE)

  df2 <- data.frame(x = c("a", "B", "d"),
                    z = 4:6,
                    stringsAsFactors = FALSE)

  check <- data.frame(x = c("A", "B", "C"),
                      y = 1:3,
                      z = c(4L, 5L, NA),
                      stringsAsFactors = FALSE)

  expect_equal(insensitive(dplyr::left_join)(df1, df2, by = "x"), check)
})
