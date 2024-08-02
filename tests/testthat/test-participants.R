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
