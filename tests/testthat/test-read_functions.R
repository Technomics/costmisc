
test_that("read_folder", {

  check_data <- list()
  for (i in 1:4) {
    check_data[[i]] <- mtcars[seq((i - 1) * 8 + 1, (i * 8)), ]
    rownames(check_data[[i]]) <- NULL
  }

  check_data1 <- check_data
  names(check_data1) <- paste0("mtcars_", 1:4, "_csv")

  check_data2 <- check_data
  names(check_data2) <- paste0("/mtcars_", 1:4, ".csv")

  check_data3 <- check_data1 %>%
    listindex_to_col("new_id")

  the_dir <- system.file("examples", package = "costmisc")

  x1 <- read_folder(the_dir, read.csv)
  x2 <- read_folder(the_dir, read.csv, .clean_file_names = FALSE)
  x3 <- read_folder(the_dir, read.csv, .id = "new_id")

  expect_equal(x1, check_data1)
  expect_equal(x2, check_data2)
  expect_equal(x3, check_data3)

})

test_that("col_rep", {

  test_str1 <- "cindlfDt?-a"
  test_str2 <- "c3n2dl3-2c"

  x <- col_rep(test_str1)
  x_readxl <- col_rep(test_str1, "readxl")
  x_sql <- col_rep(test_str1, "sql")

  x2 <- col_rep(test_str2)

  x_readxl_check <- c("text", "numeric", "numeric", "numeric", "logical", "text", "date", "date", "guess", "skip", NA)
  x_sql_check <- c("VARCHAR", "INTEGER", "DOUBLE", "DOUBLE", "BIT", "VARCHAR", "DATETIME", "DATETIME", NA, NA, "COUNTER")

  x2_check <- "cccnndlll--c"

  expect_equal(test_str1, x)
  expect_equal(x_readxl, x_readxl_check)
  expect_equal(x_sql, x_sql_check)
  expect_equal(x2, x2_check)

})

