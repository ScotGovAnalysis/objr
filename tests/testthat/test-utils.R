
# check_valid ----

test_that("Error if vector of values supplied", {

  expect_error(check_valid(c("test1", "test2")),
               class = "objr_value-invalid-length")

})

test_that("Correct value returned", {

  expect_true(check_valid("test1"))
  expect_false(check_valid(""))
  expect_false(check_valid(NA))
  expect_false(check_valid(NULL))

})

test_that("Warning returned if invalid value and warn = FALSE", {

  expect_warning(check_valid("", warn = TRUE))

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
  expect_no_error(input_value("pwd"))
  expect_no_error(input_value("proxy"))

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
