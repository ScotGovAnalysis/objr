test_that("Expect character value returned", {

  expect_type(
    error(httr2::response(status_code = 401)),
    "character"
  )

  expect_type(
    error(httr2::response(status_code = 403)),
    "character"
  )

})

test_that("NULL returned for invalid status code", {
  expect_null(
    error(httr2::response(status_code = 100))
  )
})
