
without_internet({

  test_that("Valid request created", {

    expect_GET(
      workspaces(),
      "https://secure.objectiveconnect.co.uk/publicapi/1/myworkspaces"
    )

    expect_GET(
      workspaces(workgroup_uuid = "test_workgroup"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/myworkspaces?",
             "workgroupUuid=test_workgroup")
    )

  })

})

with_mock_api({

  test_that("Function returns dataframe", {

    expect_s3_class(
      workspaces(workgroup_uuid = "test_workgroup_uuid"),
      "data.frame"
    )

    expect_equal(
      unique(
        workspaces(workgroup_uuid = "test_workgroup_uuid")$workgroup_uuid
      ),
      "test_workgroup_uuid"
    )

  })

})
