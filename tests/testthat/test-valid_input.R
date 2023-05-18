
test_that("Error if value not supplied in non-interactive environment", {

  withr::local_options(list(rlang_interactive = FALSE))

  expect_error(valid_input("usr"), class = "objectiveR_value-not-supplied")
  expect_error(valid_input("pwd"), class = "objectiveR_value-not-supplied")
  expect_error(valid_input("proxy"), class = "objectiveR_value-not-supplied")

})

test_that(paste(
  "Supplied value used regardless of interactivity and",
  "correct value returned"), {

  withr::local_options(list(rlang_interactive = TRUE))
  expect_equal(valid_input("usr", "test-usr"), "test-usr")
  expect_equal(valid_input("pwd", "test-pwd"), "test-pwd")
  expect_equal(valid_input("proxy", "test-proxy"), "test-proxy")

  withr::local_options(list(rlang_interactive = FALSE))
  expect_equal(valid_input("usr", "test-usr"), "test-usr")
  expect_equal(valid_input("pwd", "test-pwd"), "test-pwd")
  expect_equal(valid_input("proxy", "test-proxy"), "test-proxy")

})

test_that("Error if supplied value is not more than 0 characters in length", {

  expect_error(valid_input("usr", ""), class = "objectiveR_value-invalid")
  expect_error(valid_input("pwd", ""), class = "objectiveR_value-invalid")
  expect_error(valid_input("proxy", ""), class = "objectiveR_value-invalid")

})

test_that("Popup windows work", {

  # This test will only run when running interactively
  # To pass test, user must input some text when popups appear

  withr::local_options(list(rlang_interactive = TRUE))

  skip_if_not(rstudioapi::isAvailable(), "RStudio not available")

  expect_no_error(valid_input("usr"))
  expect_no_error(valid_input("pwd"))
  expect_no_error(valid_input("proxy"))

})


test_that("Error if no input to popup windows", {

  # This test will only run when running interactively
  # To pass test, user must click OK without entering any text
  # when popups appear

  withr::local_options(list(rlang_interactive = TRUE))

  skip_if_not(rstudioapi::isAvailable(), "RStudio not available")

  expect_error(valid_input("usr"), class = "objectiveR_value-invalid")
  expect_error(valid_input("pwd"), class = "objectiveR_value-invalid")
  expect_error(valid_input("proxy"), class = "objectiveR_value-invalid")

})
