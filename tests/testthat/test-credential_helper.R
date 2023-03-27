
test_that("Error if value not supplied in non-interactive environment", {

  withr::local_options(list(rlang_interactive = FALSE))

  expect_error(credential_helper("usr"))
  expect_error(credential_helper("pwd"))

})

test_that(paste(
  "Supplied value used regardless of interactivity and",
  "correct value returned"), {

  withr::local_options(list(rlang_interactive = TRUE))
  expect_equal(credential_helper("usr", "test-usr"), "test-usr")
  expect_equal(credential_helper("pwd", "test-pwd"), "test-pwd")

  withr::local_options(list(rlang_interactive = FALSE))
  expect_equal(credential_helper("usr", "test-usr"), "test-usr")
  expect_equal(credential_helper("pwd", "test-pwd"), "test-pwd")

})

test_that("Error if value is not more than 0 characters in length", {

  expect_error(credential_helper("usr", ""))
  expect_error(credential_helper("pwd", ""))

})

test_that("Popup windows work", {

  withr::local_options(list(rlang_interactive = TRUE))

  skip_if_not(rstudioapi::isAvailable(), "RStudio not available")

  expect_no_error(credential_helper("usr"))
  expect_no_error(credential_helper("pwd"))

})
