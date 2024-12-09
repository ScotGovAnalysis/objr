# objr ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      objr("me"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/me"
    )

    expect_POST(
      objr(
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

  test_that("Valid response", {
    user <- objr("me", use_proxy = TRUE)
    expect_equal(httr2::resp_body_json(user)$uuid, "1234")
  })

})


# objr_auth ----

test_that("Error if invalid request supplied", {
  expect_error(objr_auth("req"))
})

req <- httr2::request("www.example.com")

test_that("httr2 request returned", {

  .GlobalEnv$token <- "test" # nolint: object_name_linter

  expect_s3_class(objr_auth(req), "httr2_request")

  rm(token, pos = .GlobalEnv)

})

test_that("Correct authentication used", {

  expect_true(grepl("^Basic ", objr_auth(req)$headers$Authorization))

  .GlobalEnv$token <- "test" # nolint: object_name_linter

  exp_token1 <- objr_auth(req)
  expect_equal(exp_token1$headers$Authorization, "test")

  # Token used even when no username and password supplied
  with_envvar(
    new = c("OBJR_USR" = "",
            "OBJR_PWD" = ""),
    code = {
      exp_token2 <- objr_auth(req)
      expect_equal(exp_token2$headers$Authorization, "test")
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

test_that("Response returned invisibly", {

  resp <- httr2::response(headers = list(Authorization = "test1"))

  expect_invisible(store_token(resp, store_env = environment()))

  returned <- store_token(resp, store_env = environment())
  expect_equal(returned, resp)

})

test_that("Environment value created successfully", {
  httr2::response(headers = list(Authorization = "test2")) |>
    store_token(store_env = environment())
  expect_true(exists("token"))
})


# error ----

test_that("Expect character value returned", {

  expect_type(
    error(httr2::response(status_code = 400)),
    "character"
  )

  expect_type(
    error(httr2::response(status_code = 401)),
    "character"
  )

  expect_type(
    error(httr2::response(status_code = 403,
                          body = list(description = "x"))),
    "character"
  )

  expect_type(
    error(httr2::response_json(
      status_code = 403,
      body = list(description = "REQUIRES_2FA")
    )),
    "character"
  )

  expect_type(
    error(httr2::response(status_code = 404)),
    "character"
  )

})

test_that("NULL returned for invalid status code", {
  expect_null(
    error(httr2::response(status_code = 100))
  )
})


# check_pages ----

test_that("Response returned invisibly", {

  resp <- httr2::response_json()

  expect_invisible(check_pages(resp))

  returned <- check_pages(resp)

  expect_equal(returned, resp)

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

test_that("Warning and messages returned", {

  resp <- httr2::response_json(
    body = list(metadata = list(
      totalPages = 2,
      page = 0
    ))
  )

  expect_warning(check_pages(resp))

})
