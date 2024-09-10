# guess_fn ----

test_that("Correct value returned", {

  suppressMessages({
    expect_equal(guess_fn("csv", "read"), "readr::read_csv")
    expect_equal(guess_fn("rds", "write"), "readr::write_rds")
    expect_equal(guess_fn("xlsx", "write"), "writexl::write_xlsx")
  })

})

test_that("Error returned for invalid arguments", {

  expect_error(guess_fn("invalid", "read"))
  expect_error(guess_fn("x", "read"))
  expect_error(guess_fn("csv", "invalid"))
  expect_error(guess_fn("csv", "r"))

})


# write_temp ----

test_data <- data.frame(x = 1, y = NA)

test_that("Correct value returned", {

  x1 <- suppressMessages(
    write_temp(test_data, name = "test1", file_type = "csv")
  )

  expect_type(x1, "character")
  expect_true(file.exists(x1))
  expect_equal(basename(x1), "test1.csv")

  x2 <- suppressMessages(
    write_temp(test_data, name = "test2", file_type = "rds")
  )

  expect_equal(basename(x2), "test2.rds")

  x3 <- suppressMessages(
    write_temp(test_data, name = "test3", file_type = "xlsx")
  )

  expect_equal(basename(x3), "test3.xlsx")

  unlink(c(x1, x2, x3))

})

test_that("Additional arguments passed to write_fn", {

  x4 <- suppressMessages(
    write_temp(test_data,
               name = "test4",
               file_type = "csv",
               na = "MISSING")
  )

  file <- readr::read_csv(x4, show_col_types = FALSE)

  expect_equal(unique(file$y), "MISSING")

  unlink(x4)

})

test_that("Error if `file_type` not supplied", {
  expect_error(write_temp(test_data, name = "test"))
})


# read_temp ----

path <- tempfile(fileext = c(".rds", ".rds", ".csv", ".txt"))

readr::write_rds(test_data, path[1])
readr::write_rds("x", path[2])
readr::write_csv(test_data, path[3])

test_that("Correct value returned", {

  expect_s3_class(read_temp(path[1]), "data.frame")
  expect_type(read_temp(path[2]), "character")
  expect_s3_class(suppressMessages(read_temp(path[3])), "data.frame")

})

test_that("Additional arguments passed to write_fn", {

  x4 <- suppressMessages(
    write_temp(test_data,
               name = "test4",
               file_type = "csv",
               na = "MISSING")
  )

  file <- readr::read_csv(x4, show_col_types = FALSE)

  expect_equal(unique(file$y), "MISSING")

  unlink(x4)

})

writeLines("test", path[4])

test_that("Error if file not accepted type", {
  expect_error(read_temp(test_data))
})

unlink(path)
