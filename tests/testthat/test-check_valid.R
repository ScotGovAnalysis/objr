
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
