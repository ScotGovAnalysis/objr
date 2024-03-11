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
        name = "test_folder",
        workspaceUuid = "test_workspace"
      ),
      "https://secure.objectiveconnect.co.uk/publicapi/1/folders",
      '{"name":"test_folder","workspaceUuid":"test_workspace"}'
    )

  })

})
