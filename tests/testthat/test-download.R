# download_file ----

with_file("test", {

  dir.create("test")

  without_internet({

    test_that("Valid request", {

      expect_GET(
        download_file(document_uuid = "test_document",
                      folder = "test"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/",
               "documents/test_document/download")
      )

    })

  })

  with_mock_api({

    test_that("Function returns invisible", {
      expect_invisible(
        suppressMessages(download_file(document_uuid = "test_document",
                                       folder = "test"))
      )
    })

    test_that("Success message returned", {
      expect_message(download_file(document_uuid = "test_document",
                                   folder = "test",
                                   overwrite = TRUE))
    })

    test_that("New file created", {
      suppressMessages(download_file(document_uuid = "test_document",
                                     folder = "test",
                                     overwrite = TRUE))
      expect_true(file.exists(paste0("test", "/test_document_name.txt")))
    })

    test_that("Error if file already exists and `overwrite = FALSE`", {
      expect_error(
        download_file(document_uuid = "test_document",
                      folder = "test")
      )
    })

  })

})


# read_data ----

without_internet({

  test_that("Valid request", {

    expect_GET(
      read_data(document_uuid = "test_document"),
      paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents/",
             "test_document/download")
    )

  })

})
