# comments ----

without_internet({

  test_that("Valid request created", {

    expect_GET(
      comments(),
      "https://secure.objectiveconnect.co.uk/publicapi/1/comments"
    )

    expect_GET(
      comments(created_after = as.Date("2024-01-01"),
               thread_uuid = "test_thread",
               mention_uuid = "test_mention",
               workgroup_uuid = "test_workgroup",
               page = "test_page",
               size = "test_size"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/comments?",
             "createdAfter=",
             as.integer(as.POSIXct("2024-01-01 00:00:01")) * 1000, "&",
             "threadUuid=test_thread&",
             "mentionUuid=test_mention&",
             "workgroupUuid=test_workgroup&",
             "page=test_page&",
             "size=test_size")
    )

  })

})

with_mock_api({

  test_that("Function returns data frame", {

    expect_s3_class(
      comments(),
      "data.frame"
    )

  })

})


# new_thread ----

without_internet({

  test_that("Valid request created", {

    expect_POST(
      new_thread(workspace_uuid = "test_workspace",
                 text = "test message",
                 mentioned_assets = c("test_asset1", "test_asset2"),
                 mentioned_users = "test_user"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/threads",
      "{\"workspaceUuid\":\"test_workspace\",",
      "\"text\":\"test message\",",
      "\"mentionedAssets\":[[\"test_asset1\",\"test_asset2\"]],",
      "\"mentionedUsers\":[\"test_user\"]}"
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(
        new_thread(workspace_uuid = "test_workspace_uuid", text = "test_text")
      )
    )

  })

  test_that("Function returns success message", {

    expect_message(
      new_thread(workspace_uuid = "test_workspace_uuid", text = "test_text")
    )

  })

})


# new_reply ----

without_internet({

  test_that("Valid request created", {

    expect_POST(
      new_reply(thread_uuid = "test_thread",
                text = "test message",
                mentioned_assets = c("test_asset1", "test_asset2"),
                mentioned_users = "test_user"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/replies",
      "{\"threadUuid\":\"test_thread\",",
      "\"text\":\"test message\",",
      "\"mentionedAssets\":[[\"test_asset1\",\"test_asset2\"]],",
      "\"mentionedUsers\":[\"test_user\"]}"
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(
        new_reply(thread_uuid = "test_thread_uuid", text = "test_text")
      )
    )

  })

  test_that("Function returns success message", {

    expect_message(
      new_reply(thread_uuid = "test_thread_uuid", text = "test_text")
    )

  })

})


# convert_to_epoch ----

test_that("Error produced if not NULL or datetime", {

  expect_error(convert_to_epoch("invalid"))
  expect_error(convert_to_epoch(NA))
  expect_error(convert_to_epoch("2024-01-01"))
  expect_error(convert_to_epoch(20240101))

})

test_that("Correct value returned", {

  expect_equal(
    convert_to_epoch(as.POSIXct("2024-01-01 09:00:00")),
    1704099600000
  )

  expect_equal(
    convert_to_epoch(as.POSIXct("2024-01-01")),
    1704067200000
  )

  expect_equal(convert_to_epoch(NULL), NULL)

})
