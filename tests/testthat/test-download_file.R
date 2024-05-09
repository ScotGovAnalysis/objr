without_internet({

  test_that("Valid request", {

    expect_GET(
      download_file(document_uuid = "test_document",
                    folder = "test"),
      "https://secure.objectiveconnect.co.uk/publicapi/1/assets/test_document"
    )

  })

})

with_mock_api({

  with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),

    code = {

      test_that("Function returns invisible", {

        expect_invisible(
          suppressMessages(download_file(document_uuid = "test_document",
                                         folder = tempdir()))
        )

      })

      test_that("Function returns success message", {

        expect_message(download_file(document_uuid = "test_document",
                                     folder = tempdir()))

      })

      test_that("Function creates new file", {
        suppressMessages(download_file(document_uuid = "test_document",
                                       folder = tempdir()))
        expect_true(file.exists(paste0(tempdir(), "/test_document_name.txt")))
      })

      file.remove(paste0(tempdir(), "/test_document_name.txt"))

    })

})
