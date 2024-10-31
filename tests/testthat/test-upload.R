# upload_file and upload_file_version ----

with_file("test", {

  file.create("test")

  without_internet({

    test_that("Valid request", {

      expect_POST(
        upload_file(file = "test",
                    uuid = "test_workspace"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents ",
               "Multipart form:\n  ",
               "name = test\n  ",
               "workspaceUuid = test_workspace\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

      expect_POST(
        upload_file(file = "test",
                    name = "test_file_name",
                    uuid = "test_workspace"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents ",
               "Multipart form:\n  ",
               "name = test_file_name\n  ",
               "workspaceUuid = test_workspace\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

      expect_POST(
        upload_file_version(file = "test",
                            uuid = "test_asset"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/",
               "documents/test_asset/upload ",
               "Multipart form:", "\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

    })

  })


  with_mock_api({

    test_that("Function returns invisible", {

      expect_invisible(
        suppressMessages(upload_file_version(file = "test",
                                             uuid = "test_asset"))
      )

      expect_invisible(
        suppressMessages(upload_file(file = "test",
                                     uuid = "test_workspace"))
      )

    })

    test_that("Function returns success message", {

      expect_message(upload_file_version(file = "test",
                                         uuid = "test_asset"))

    })

  })

})


# write_data and write_data_version ----

without_internet({

  expect_POST(
    write_data(head(mtcars),
               file_name = "test1",
               file_type = "csv",
               uuid = "test_workspace"),
    paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents ",
           "Multipart form:\n  ",
           "name = test1\n  ",
           "workspaceUuid = test_workspace\n  ",
           "file = File: 92b4327fdd7b86c862ec5f0d9e5e6bd8")
  )

})
