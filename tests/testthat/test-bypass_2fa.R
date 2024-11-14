without_internet({

  test_that("Valid request", {

    expect_PUT(
      workgroup_bypass_2fa(workgroup_uuid = "test_workgroup"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/workgroups/",
             "test_workgroup/bypassTwoStepAllowed"),
      "{\"bypassTwoStepAllowed\":\"true\"}"
    )

    expect_PUT(
      workgroup_bypass_2fa(workgroup_uuid = "test_workgroup",
                           allow_bypass = FALSE),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/workgroups/",
             "test_workgroup/bypassTwoStepAllowed"),
      "{\"bypassTwoStepAllowed\":\"false\"}"
    )

    expect_PUT(
      participant_bypass_2fa(participant_uuid = "test_user"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/participants/",
             "test_user/bypassTwoStep"),
      "{\"bypassTwoStep\":\"true\"}"
    )

    expect_PUT(
      participant_bypass_2fa(
        participant_uuid = "test_user",
        allow_bypass = FALSE
      ),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/participants/",
             "test_user/bypassTwoStep"),
      "{\"bypassTwoStep\":\"false\"}"
    )

  })

})

with_mock_api({

  test_that("Functions returns invisible", {

    expect_invisible(
      suppressMessages(
        workgroup_bypass_2fa("test_workgroup")
      )
    )

    expect_invisible(
      suppressMessages(
        participant_bypass_2fa("test_participant")
      )
    )

  })

  test_that("Functions return success message", {

    expect_message(workgroup_bypass_2fa("test_workgroup"))
    expect_message(participant_bypass_2fa("test_participant"))

  })

})
