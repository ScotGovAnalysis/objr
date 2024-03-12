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

with_mock_api({

  withr::with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd",
            "OBJECTIVER_PROXY" = "test_proxy"),

    code = {

      test_that("Valid response", {
        user <- objectiveR("me", use_proxy = TRUE)
        expect_equal(httr2::resp_body_json(user)$uuid, "1234")
      })

    })

})
