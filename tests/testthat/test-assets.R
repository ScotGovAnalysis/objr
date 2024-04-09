# workspace_assets ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      workspace_assets(workspace_uuid = "test_workspace"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets?",
             "workspaceUuid=test_workspace&type=DOCUMENT%7CFOLDER%7CLINK")
    )

    expect_GET(
      workspace_assets(workspace_uuid = "test_workspace",
                       type = list("folder")),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/assets?",
             "workspaceUuid=test_workspace&type=FOLDER")
    )

    expect_error(
      workspace_assets(workspace_uuid = "test_workspace",
                       type = "folder")
    )

  })

})

with_mock_api({

  withr::with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),

    code = {

      test_that("Function returns dataframe", {

        expect_s3_class(
          workspace_assets(workspace_uuid = "test_workspace"),
          "data.frame"
        )

        expect_equal(
          unique(
            workspace_assets(workspace_uuid = "test_workspace")$type
          ),
          c("DOCUMENT", "FOLDER")
        )

        expect_equal(
          unique(
            workspace_assets(workspace_uuid = "test_workspace", type = list("folder"))$type
          ),
          "FOLDER"
        )

      })

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

  withr::with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),

    code = {

      test_that("Function returns dataframe", {

        expect_type(
          asset_info(asset_uuid = "test_asset"),
          "list"
        )

        expect_named(
          asset_info(asset_uuid = "test_asset")
        )

      })

    })

})


