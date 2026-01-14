# assets ----

test_that("Error if `type` invalid", {
  expect_error(assets(workspace_uuid = "test_workspace",
                      type = c("document", "link")))
  expect_error(assets(workspace_uuid = "test_workspace",
                      type = "x"))
})

without_internet({

  test_that("Valid request created", {

    expect_GET(
      assets(workspace_uuid = "test_workspace"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets?",
             "workspaceUuid=test_workspace")
    )

    expect_GET(
      assets(workspace_uuid = "test_workspace",
             type = "folder"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets?",
             "workspaceUuid=test_workspace&type=FOLDER")
    )

  })

  test_that("Deprecated `type` list format handled correctly", {

    expect_GET(
      suppressWarnings(
        assets(workspace_uuid = "test_workspace",
               type = list("folder"))
      ),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets?",
             "workspaceUuid=test_workspace")
    )

  })

})

with_mock_api({

  test_that("Function returns tibble", {

    expect_s3_class(
      assets(workspace_uuid = "test_workspace_uuid"),
      "tbl"
    )

  })

  test_that("Results filtered by type", {
    expect_equal(
      unique(
        assets(workspace_uuid = "test_workspace_uuid",
               type = "folder")$asset_type
      ),
      "FOLDER"
    )
  })

})


# asset_info ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      asset_info(asset_uuid = "test_asset"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/assets/test_asset"
    )

  })

})

with_mock_api({

  test_that("Function returns tibble", {

    expect_s3_class(
      asset_info(asset_uuid = "test_asset"),
      "tbl"
    )

  })

})


# delete_asset ----

without_internet({

  test_that("Valid request", {

    expect_DELETE(
      delete_asset(asset_uuid = "test_asset_uuid"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets/",
             "test_asset_uuid")
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(delete_asset(asset_uuid = "test_asset_uuid"))
    )

  })

  test_that("Function returns success message", {

    expect_message(delete_asset(asset_uuid = "test_asset_uuid"))

  })

})



# rename_asset ----

without_internet({

  test_that("Valid request", {

    expect_PUT(
      rename_asset(asset_uuid = "test_asset_uuid",
                   new_name = "test_new_name"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets/",
             "test_asset_uuid/name")
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(rename_asset(asset_uuid = "test_asset_uuid",
                                    new_name = "test_new_name"))
    )

  })

  test_that("Function returns success message", {

    expect_message(rename_asset(asset_uuid = "test_asset_uuid",
                                new_name = "test_new_name"))

  })

})
