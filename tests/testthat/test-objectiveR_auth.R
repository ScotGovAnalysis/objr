
req <- httr2::request("www.example.com")

test_that("Error if invalid request supplied", {
  expect_error(objectiveR_auth("req"))
})

test_that("httr2 request returned", {

  expect_s3_class(objectiveR_auth(req, usr = "test", pwd = "test"),
                  "httr2_request")

  .GlobalEnv$token <- "test"
  expect_s3_class(objectiveR_auth(req), "httr2_request")

  rm(token, pos = .GlobalEnv)

})

test_that("Correct authentication used", {

  exp_usr_pwd <- objectiveR_auth(req, usr = "test", pwd = "test")
  expect_true(grepl("^Basic ", exp_usr_pwd$headers$Authorization))

  .GlobalEnv$token <- "test"

  exp_token1 <- objectiveR_auth(req)
  expect_equal(exp_token1$headers$Authorization, "test")

  # token used even when username and password supplied
  exp_token2 <- objectiveR_auth(req, usr = "test", pwd = "test")
  expect_equal(exp_token1$headers$Authorization, "test")

  rm(token, pos = .GlobalEnv)

})

