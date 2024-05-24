# objectiveR ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      objectiveR("me"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/me"
    )

    expect_POST(
      objectiveR(
        "folders",
        method = "POST",
        body = list(name = "test_folder",
                    workspaceUuid = "test_workspace")
      ),
      "https://secure.objectiveconnect.co.uk/publicapi/1/folders",
      '{"name":"test_folder","workspaceUuid":"test_workspace"}'
    )

  })

})

with_mock_api({

  with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd",
            "OBJECTIVER_PROXY" = "test_proxy"),

    code = {

      test_that("Valid response", {
        user <- objectiveR("me", use_proxy = TRUE)
        expect_equal(httr2::resp_body_json(user)$uuid, "1234")
      })

    })

})


# objectiveR_auth ----

req <- httr2::request("www.example.com")

test_that("Error if invalid request supplied", {
  expect_error(objectiveR_auth("req"))
})

test_that("httr2 request returned", {

  # expect_s3_class(objectiveR_auth(req, usr = "test", pwd = "test"),
  #                 "httr2_request")

  .GlobalEnv$token <- "test"
  expect_s3_class(objectiveR_auth(req), "httr2_request")

  rm(token, pos = .GlobalEnv)

})

test_that("Correct authentication used", {

  with_envvar(
    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),
    code = {
      exp_usr_pwd <- objectiveR_auth(req)
      expect_true(grepl("^Basic ", exp_usr_pwd$headers$Authorization))
    }
  )

  .GlobalEnv$token <- "test"

  exp_token1 <- objectiveR_auth(req)
  expect_equal(exp_token1$headers$Authorization, "test")

  # Token used even when username and password supplied
  with_envvar(
    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),
    code = {
      exp_token2 <- objectiveR_auth(req)
      expect_equal(exp_token1$headers$Authorization, "test")
    }
  )

  rm(token, pos = .GlobalEnv)

})


# store_token ----

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
})

test_that("Environment value created successfully", {
  httr2::response(headers = list(Authorization = "test2")) |>
    store_token(store_env = environment())
  expect_true(exists("token"))
})


# error ----

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


# check_pages ----

test_that("NULL returned", {

  expect_null(
    check_pages(httr2::response_json())
  )

  expect_null(
    check_pages(httr2::response_json(
      body = list(content = "test_content")
    ))
  )

  resp1 <- httr2::response_json(
    body = list(metadata = list(
      totalPages = 1,
      page = 0
    ))
  )

  expect_null(check_pages(resp1))

})

test_that("Error returned", {

  resp1 <- httr2::response_json(
    body = list(metadata = list(
      totalPages = 2
    ))
  )

  expect_error(check_pages(resp1), class = "metadata-values-dont-exist")

  resp2 <- httr2::response_json(
    body = list(metadata = list(
      totalPages = 2,
      page = 4
    ))
  )

  expect_error(check_pages(resp2), class = "page-doesnt-exist")

})

test_that("Warning and message returned", {

  resp <- httr2::response_json(
    body = list(metadata = list(
      totalPages = 2,
      page = 0
    ))
  )

  expect_warning(suppressMessages(check_pages(resp)))
  expect_message(suppressWarnings(check_pages(resp)))

})
