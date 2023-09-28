
test_that("Error if invalid response supplied", {
  expect_error(store_token("resp"))
})

test_that("Error if Authorization header doesn't exist", {
  expect_error(store_token(httr2::response()))
})

test_that("Function returns invisible object", {
  expect_invisible(
    httr2::response(headers = list(Authorization = "test1")) |>
      store_token(store_env = environment())
  )
  rm(test, envir = environment())
})

test_that("Environment value created successfully", {
  httr2::response(headers = list(Authorization = "test2")) |>
    store_token(store_env = environment())
  expect_true(exists("token"))
  expect_equal(get("token"), "test2")
  rm(test, envir = environment())
})
