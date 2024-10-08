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
