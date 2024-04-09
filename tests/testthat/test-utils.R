
# check_valid ----

test_that("Error if vector of values supplied", {

  expect_error(check_valid(c("test1", "test2")),
               class = "objectiveR_value-invalid-length")

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

  withr::with_envvar(
    new = c("OBJECTIVER_USR" = "test_usr"),
    code = expect_equal(input_value("usr"), "test_usr")
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PWD" = "test_pwd"),
    code = expect_equal(input_value("pwd"), "test_pwd")
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = "test_proxy"),
    code = expect_equal(input_value("proxy"), "test_proxy")
  )

})

test_that("Error if envvar doesn't exist and not interactive", {

  withr::local_options(list(rlang_interactive = FALSE))

  withr::with_envvar(
    new = c("OBJECTIVER_USR" = NA),
    code = expect_error(input_value("usr"), class = "objectiveR_invalid-envvar")
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PWD" = NA),
    code = expect_error(input_value("pwd"), class = "objectiveR_invalid-envvar")
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = NA),
    code = expect_error(input_value("proxy"), class = "objectiveR_invalid-envvar")
  )

})

test_that("Popup input works", {

  # This test will only run when running interactively
  # To pass test, user must input some text when popups appear

  withr::local_options(list(rlang_interactive = TRUE))

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
