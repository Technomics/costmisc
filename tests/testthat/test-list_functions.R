
test_that("list stack and ID functions", {

  test_data <- list(file1 = list(mtcars = mtcars[1:3,],
                                 iris = iris[1:3,]),
                    file2 = list(mtcars = mtcars[4:6,],
                                 iris = iris[4:6,]),
                    file3 = list(mtcars = mtcars[7:9,],
                                 iris = iris[7:9,]))

  # check unnest_df
  check_data <- list(iris = iris[1:9,],
                     mtcars = mtcars[1:9,])

  expect_equal(unnest_df(test_data), check_data)

  # check add_id_col
  check_data2 <- sapply(check_data, function(df) cbind(doc_id = 1L, df))
  check_data3 <- sapply(check_data, function(df) cbind(new_id = 15, df))

  expect_equal(add_id_col(check_data), check_data2)
  expect_equal(add_id_col(check_data, 15, "new_id"), check_data3)

  # check listindex_to_col
  check_data4 <- sapply(1:2, function(x) cbind(doc_id = x, check_data[[x]]))
  names(check_data4) <- names(check_data)
  check_data5 <- sapply(1:2, function(x) cbind(new_id = rep(1:3, each = 3), check_data[[x]]))
  names(check_data5) <- names(check_data)

  expect_equal(listindex_to_col(check_data), check_data4)
  expect_equal(unnest_df(listindex_to_col(test_data, "new_id")), check_data5)
})
