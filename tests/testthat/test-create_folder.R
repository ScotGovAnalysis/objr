without_internet({

  test_that("Valid request created", {

    expect_POST(
      create_folder(
        folder_name = "test_folder",
        workspace_uuid = "test_workspace"
      ),
      "https://secure.objectiveconnect.co.uk/publicapi/1/folders",
      paste0("{\"name\":\"test_folder\",",
             "\"workspaceUuid\":\"test_workspace\",",
             "\"parentUuid\":null,",
             "\"description\":null}")
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(create_folder(
        folder_name = "test_folder_name",
        workspace_uuid = "test_workspace"
      ))
    )

  })

  test_that("Valid response without parent folder", {

    resp <- suppressMessages(create_folder(
      folder_name = "test_folder_name",
      workspace_uuid = "test_workspace"
    ))

    expect_equal(resp$type, "FOLDER")
    expect_equal(resp$name, "test_folder_name")
    expect_equal(resp$workspaceUuid, "test_workspace")

  })

  test_that("Valid response with parent folder", {

    resp <- suppressMessages(create_folder(
      folder_name = "test_folder_name",
      workspace_uuid = "test_workspace",
      parent_uuid = "test_parent"
    ))

    expect_equal(resp$type, "FOLDER")
    expect_equal(resp$name, "test_folder_name")
    expect_equal(resp$workspaceUuid, "test_workspace")
    expect_equal(resp$parentUuid, "test_parent")

  })

})
