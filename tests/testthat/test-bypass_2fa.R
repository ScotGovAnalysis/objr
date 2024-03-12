without_internet({

  test_that("Valid request", {

    expect_PUT(
      allow_bypass_2fa(workgroup_uuid = "test_workgroup"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/workgroups/",
             "test_workgroup/bypassTwoStepAllowed"),
      "{\"bypassTwoStepAllowed\":\"true\"}"
    )

    expect_PUT(
      allow_bypass_2fa(workgroup_uuid = "test_workgroup", allow_bypass = FALSE),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/workgroups/",
             "test_workgroup/bypassTwoStepAllowed"),
      "{\"bypassTwoStepAllowed\":\"false\"}"
    )

    expect_PUT(
      participant_bypass_2fa(user_uuid = "test_user"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/participants/",
             "test_user/bypassTwoStep"),
      "{\"bypassTwoStep\":\"true\"}"
    )

    expect_PUT(
      participant_bypass_2fa(user_uuid = "test_user", allow_bypass = FALSE),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/participants/",
             "test_user/bypassTwoStep"),
      "{\"bypassTwoStep\":\"false\"}"
    )

  })

})

with_mock_api({

  withr::with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),

    code = {

      test_that("Functions returns invisible", {

        expect_invisible(
          suppressMessages(
            allow_bypass_2fa("test_workgroup")
          )
        )

      })

    })

})


