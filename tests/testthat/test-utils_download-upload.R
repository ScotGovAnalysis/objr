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
    write_temp(test_data, file_name = "test1", file_type = "csv")
  )

  expect_type(x1, "character")
  expect_true(file.exists(x1))
  expect_equal(basename(x1), "test1.csv")

  x2 <- suppressMessages(
    write_temp(test_data, file_name = "test2", file_type = "rds")
  )

  expect_equal(basename(x2), "test2.rds")

  x3 <- suppressMessages(
    write_temp(test_data, file_name = "test3", file_type = "xlsx")
  )

  expect_equal(basename(x3), "test3.xlsx")

  unlink(c(x1, x2, x3))

})

test_that("Additional arguments passed to write_fn", {

  x4 <- suppressMessages(
    write_temp(test_data,
               file_name = "test4",
               file_type = "csv",
               na = "MISSING")
  )

  file <- readr::read_csv(x4, show_col_types = FALSE)

  expect_equal(unique(file$y), "MISSING")

  unlink(x4)

})

test_that("Error if `file_type` not supplied", {
  expect_error(write_temp(test_data, file_name = "test"))
})


# read_temp ----

with_tempfile("test_rds", fileext = ".rds", {

  test_that("Correct value returned", {

    readr::write_rds(test_data, test_rds)
    expect_s3_class(read_temp(test_rds), "data.frame")

    readr::write_rds("x", test_rds)
    expect_type(read_temp(test_rds), "character")

  })

})

with_tempfile("temp_csv", fileext = ".csv", {

  readr::write_csv(test_data, temp_csv)

  test_that("Additional arguments passed to read_fn", {
    x <- read_temp(temp_csv, id = "id", show_col_types = FALSE)
    expect_true("id" %in% names(x))
  })

})

with_tempfile("test_txt", fileext = ".txt", {

  file.create(test_txt)

  test_that("Error if file not accepted type", {
    expect_error(read_temp(test_txt))
  })

})


# check_file_exists ----

with_tempfile("test", {

  file.create(test)

  test_that("Returns invisibly", {
    expect_invisible(check_file_exists(test))
  })

  test_that("Returns path", {
    x <- check_file_exists(test)
    expect_equal(x, test)
  })

  test_that("Error if path doesn't exist", {
    expect_error(check_file_exists("test1"))
  })

})


# create_file ----

test_that("Error if folder doesn't exist", {

  expect_error(create_file("folder"))

})

with_tempdir({

  test_that("Returns invisibly", {
    expect_invisible(create_file(tempdir()))
  })

  test_that("Returns file path in folder", {

    expect_type((create_file(tempdir())), "character")

    # Use gsub as dirname returns a path using / (instead of \\ like tempdir())
    expect_equal(dirname(create_file(tempdir())),
                 gsub("\\\\", "/", tempdir()))

  })

})


# rename_file ----

resp <- httr2::response(
  headers = list(`Content-Disposition` = "filename=\"new_name.csv\"")
)

test_that("Error if temp_file doesn't exist", {
  expect_error(rename_file(temp_path = "test", resp))
})

with_tempfile(c("test", "new"), {

  file.create(test)
  file.create(new)

  resp_new <- httr2::response(
    headers = list(
      `Content-Disposition` = paste0("filename=\"", basename(new), "\"")
    )
  )

  test_that("Error if file already exists", {
    expect_error(rename_file(test, resp_new))
  })

  test_that("No error if overwrite = TRUE", {
    expect_no_error(rename_file(test, resp_new, overwrite = TRUE))
  })

  unlink(file.path(dirname(test), "new_name.csv"))

})

with_tempfile(c("test1", "test2"), {

  file.create(test1)
  file.create(test2)

  test_that("Error if new_file_name include file ext", {
    expect_error(rename_file(test1, resp, new_file_name = "x.csv"))
  })

  test_that("File is renamed from response header", {
    rename_file(test1, resp)
    expect_false(file.exists(test1))
    expect_true(file.exists(file.path(dirname(test1), "new_name.csv")))
  })

  test_that("File is renamed from supplied new file name", {
    rename_file(test2, resp, new_file_name = "new_name2")
    expect_false(file.exists(test2))
    expect_true(file.exists(file.path(dirname(test2), "new_name2.csv")))
  })

  unlink(file.path(dirname(test1), "new_name.csv"))
  unlink(file.path(dirname(test2), "new_name2.csv"))

})

with_tempfile("test", {

  file.create(test)

  test_that("Returns invisibly", {
    expect_invisible(rename_file(test, resp))
  })

  unlink(file.path(dirname(test), "new_name.csv"))

})

with_tempfile("test", {

  file.create(test)

  test_that("New file path returned", {
    expect_equal(
      (rename_file(test, resp)),
      file.path(dirname(test), "new_name.csv")
    )
  })

  unlink(file.path(dirname(test), "new_name.csv"))

})


# file_name_from_header ----

test_that("Error if no `Content-Disposition` header", {
  expect_error(file_name_from_header(
    httr2::response(headers = list(x = 1))
  ))
})

test_that("Error if header in unexpected format", {
  expect_error(file_name_from_header(
    httr2::response(headers = list(`Content-Disposition` = "x"))
  ))
})

test_that("Correct value returned", {
  expect_equal(
    file_name_from_header(
      httr2::response(
        headers = list(
          `Content-Disposition` = "filename=\"ayrshire%20%26%20arran.csv\""
        )
      )
    ),
    "ayrshire & arran.csv"
  )
})
