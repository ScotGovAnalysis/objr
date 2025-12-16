
# check_valid ----

test_that("Error if vector of values supplied", {

  expect_error(check_valid(c("test1", "test2")),
               class = "objr_value-invalid-length")

})

test_that("Correct value returned", {

  expect_true(check_valid("test1"))
  expect_false(check_valid(""))
  expect_false(check_valid("  "))
  expect_false(check_valid(NA))
  expect_false(check_valid(NULL))

})

test_that("Warning only returned if warn = TRUE", {

  expect_warning(check_valid("", warn = TRUE),
                 class = "objr_value-invalid")
  expect_no_warning(check_valid("", warn = FALSE))

})


# input_value ----

test_that("Error if invalid type supplied", {
  expect_error(input_value("test"))
})

test_that("Correct value returned when environment variable exists", {

  with_envvar(
    new = c("OBJR_USR" = "test_usr"),
    code = expect_equal(input_value("usr"), "test_usr")
  )

  with_envvar(
    new = c("OBJR_PWD" = "test_pwd"),
    code = expect_equal(input_value("pwd"), "test_pwd")
  )

  with_envvar(
    new = c("OBJR_PROXY" = "test_proxy"),
    code = expect_equal(input_value("proxy"), "test_proxy")
  )

  with_envvar(
    new = c("OBJR_PROXY" = "test_proxy "),
    code = expect_equal(input_value("proxy"), "test_proxy")
  )

})

test_that("Error if envvar white space only", {

  with_envvar(
    new = c("OBJR_PROXY" = " "),
    code = expect_error(input_value("proxy"), class = "objr_invalid-envvar")
  )

})

test_that("Error if envvar doesn't exist and not interactive", {

  local_options(list(rlang_interactive = FALSE))

  with_envvar(
    new = c("OBJR_USR" = NA),
    code = expect_error(input_value("usr"), class = "objr_invalid-envvar")
  )

  with_envvar(
    new = c("OBJR_PWD" = NA),
    code = expect_error(input_value("pwd"), class = "objr_invalid-envvar")
  )

  with_envvar(
    new = c("OBJR_PROXY" = NA),
    code = expect_error(input_value("proxy"), class = "objr_invalid-envvar")
  )

})

test_that("Popup input works", {

  # This test will only run when running interactively
  # To pass test, user must input some text when popups appear

  local_options(list(rlang_interactive = TRUE))
  skip_if_not(rstudioapi::isAvailable(), "RStudio not available")
  expect_no_error(input_value("usr"))

})


# form_data_null ----

test_that("Correct value returned", {

  expect_null(form_data_null(NULL))

  expect_s3_class(form_data_null("test"), "form_data")

})


# random_uuid ----

test_that("Single character value returned", {

  expect_type(random_uuid(), "character")

  expect_length(random_uuid(), 1)

})

test_that("Returned value format correct", {

  pattern_exp <- paste(rep("[a-z0-9]{4}", 8), collapse = "-")

  expect_true(grepl(pattern = pattern_exp, x = random_uuid()))

})

test_that("Not setting seed returns random value", {

  sample_5 <- replicate(5, random_uuid())

  expect_true(length(unique(sample_5)) == 5)

})

test_that("Setting seed returns consistent value", {

  expect_identical(
    random_uuid(1234),
    random_uuid(1234)
  )

})


# check_uuid ----

test_that("Function returns UUID invisibly", {

  expect_invisible(check_uuid(random_uuid()))

  uuid <- random_uuid(1)
  expect_equal(uuid, random_uuid(1))

})

test_that("Error returned if string not supplied", {

  expect_error(check_uuid(1))
  expect_error(check_uuid(c(random_uuid(1), random_uuid(2))))

})

test_that("Error returned if string not valid UUID", {

  expect_error(check_uuid("invalid_uuid"))
  expect_error(check_uuid(substr(random_uuid(1), 1, 9)))

})


# check_list ----

test_that("Error returned", {

  expect_error(check_list("x"))
  expect_error(check_list(NULL, allow_null = FALSE))

})

test_that("`x` returned invisibly", {

  expect_invisible(check_list(list("x")))
  expect_invisible(check_list(NULL))

  x <- check_list(list("x"))
  expect_equal(x, list("x"))

})


# convert_to_epoch ----

test_that("Error produced if not NULL or POSIXct", {

  expect_error(convert_to_epoch("invalid"))
  expect_error(convert_to_epoch(NA))
  expect_error(convert_to_epoch("2024-01-01"))
  expect_error(convert_to_epoch(20240101))
  expect_error(convert_to_epoch(as.Date("2024-01-01")))

})

test_that("Correct value returned", {

  expect_equal(
    convert_to_epoch(as.POSIXct("2024-01-01 09:00:00")),
    1704099600000
  )

  expect_equal(
    convert_to_epoch(as.POSIXct("2024-01-01")),
    1704067200000
  )

  expect_equal(convert_to_epoch(NULL), NULL)

})


# convert_from_epoch ----

test_that("Error produced if not NULL or numeric", {

  expect_error(convert_from_epoch("invalid"))
  expect_error(convert_from_epoch(NA))
  expect_error(convert_from_epoch(as.Date("2024-01-01")))

})

test_that("Correct value returned", {

  expect_equal(
    convert_from_epoch(1704099600000),
    as.POSIXct("2024-01-01 09:00:00")
  )

  expect_equal(convert_from_epoch(NULL), NULL)

})
