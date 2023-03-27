
test_that("Error if invalid response supplied", {
  expect_error(store_bearer("response"))
})

test_that("Error if Authorization header not present", {
  expect_error(store_bearer(httr2::response()))
})

test_that("Bearer env variable created and correct", {

  expect_false(exists("bearer", where = .GlobalEnv))

  store_bearer(httr2::response(headers = list(Authorization = "bearer test")),
               store_env = .GlobalEnv)

  expect_true(exists("bearer", where = .GlobalEnv))

  expect_equal(get("bearer", pos = .GlobalEnv), "test")

  rm(bearer, pos = .GlobalEnv)

})

test_that("Bearer value returned invisibly", {

  expect_invisible(
    store_bearer(httr2::response(headers = list(Authorization = "bearer test")))
  )

  x <- store_bearer(
    httr2::response(headers = list(Authorization = "bearer test"))
  )

  expect_equal(x, "test")

  rm(bearer, pos = .GlobalEnv)

})
