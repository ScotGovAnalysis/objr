
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
