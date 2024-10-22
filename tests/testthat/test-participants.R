# participants ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      participants(workspace_uuid = "test_workspace"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/participants",
             "?workspaceUuid=test_workspace")
    )

  })

})

with_mock_api({

  test_that("Function returns dataframe", {

    expect_s3_class(
      participants(
        workspace_uuid = "test_workspace_uuid"
      ),
      "data.frame"
    )

  })

})


# add_participants ----

without_internet({

  test_that("Valid request created", {
    expect_POST(
      add_participants(workspace_uuid = "test_workspace",
                       emails = "test_email",
                       send_email_invite = FALSE,
                       permissions = "Delete"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/participants",
      "{\"workspaceUuid\":\"test_workspace\",\"emails\":[\"test_email\"],",
      "\"isSilent\":\"true\",\"message\":null,\"type\":\"STANDARD\",",
      "\"hasDelete\":\"true\"}"
    )
  })

})

test_that("Error if invalid permission supplied", {
  expect_error(
    add_participants(workspace_uuid = "test_workspace",
                     emails = "test_email",
                     permissions = "invalid")
  )
})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(add_participants(
        workspace_uuid = "test_workspace",
        emails = "test_email"
      ))
    )

  })

  test_that("Success message", {
    expect_message(
      add_participants(
        workspace_uuid = "test_workspace",
        emails = "test_email"
      )
    )
  })

})
