
req <- httr2::request("www.example.com")

test_that("Error if invalid request supplied", {
  expect_error(objectiveR_auth("req"))
})

test_that("httr2 request returned", {

  expect_s3_class(objectiveR_auth(req, usr = "test", pwd = "test"),
                  "httr2_request")

  .GlobalEnv$bearer <- "test"
  expect_s3_class(objectiveR_auth(req), "httr2_request")

  rm(bearer, pos = .GlobalEnv)

})

test_that("Correct authentication used", {

  exp_usr_pwd <- objectiveR_auth(req, usr = "test", pwd = "test")
  expect_true(grepl("^Basic ", exp_usr_pwd$headers$Authorization))

  .GlobalEnv$bearer <- "test"

  exp_bearer1 <- objectiveR_auth(req)
  expect_equal(exp_bearer1$headers$Authorization, paste("Bearer", bearer))

  # Bearer used even when username and password supplied
  exp_bearer2 <- objectiveR_auth(req, usr = "test", pwd = "test")
  expect_equal(exp_bearer1$headers$Authorization, paste("Bearer", bearer))

  rm(bearer, pos = .GlobalEnv)

})

