
test_that("Error if invalid code supplied", {
  expect_error(mobile_auth_login(000000))
  expect_error(mobile_auth_login(TRUE))
  expect_error(mobile_auth_login(" "))
})

test_that("Error if no code supplied and not interactive", {
  local_options(list(rlang_interactive = FALSE))
  expect_error(mobile_auth_login())
})

without_internet({

  test_that("Valid request", {

    expect_GET(
      mobile_auth_status(),
      "https://secure.objectiveconnect.co.uk/publicapi/1/mobileauth"
    )

    expect_PUT(
      mobile_auth_login("1234"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/mobileauth/login",
      "{\"totp\":\"1234\"}"
    )

  })

})


with_mock_api({

  test_that("Function returns correct value", {
    expect_equal(
      mobile_auth_status(),
      list(mobileAuthLogin = TRUE, mobileAuthRegistered = TRUE)
    )
  })

  test_that("Function returns invisible", {
    expect_invisible(
      suppressMessages(
        mobile_auth_login("1234")
      )
    )
  })

  test_that("Function returns success message", {
    expect_message(mobile_auth_login("1234"))
  })

})
