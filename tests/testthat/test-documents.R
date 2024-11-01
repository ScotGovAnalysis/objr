# versions ----

without_internet({

  test_that("Valid request", {

    expect_GET(
      versions(document_uuid = "test_document_uuid"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/",
             "documentversions?documentUuid=test_document_uuid")
    )

  })

})

with_mock_api({

  test_that("Function returns dataframe", {

    expect_s3_class(
      versions(document_uuid = "test_document_uuid"),
      "data.frame"
    )

  })

})


# rollback_to_version ----

without_internet({

  test_that("Valid request", {

    expect_PUT(
      rollback_to_version(document_uuid = "test_document_uuid",
                          version_uuid = "test_version_uuid"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/",
             "documents/test_document_uuid/rollback"),
      "{\"targetVersionUuid\":\"test_version_uuid\"}"
    )

  })

})

with_mock_api({

  test_that("Function returns invisible", {

    expect_invisible(
      suppressMessages(rollback_to_version(document_uuid = "test_document",
                                           version_uuid = "test_version"))
    )

  })

  test_that("Function returns success message", {

    expect_message(rollback_to_version(document_uuid = "test_document",
                                       version_uuid = "test_version"))

  })

})
