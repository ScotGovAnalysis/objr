with_file("test", {

  file.create("test")

  without_internet({

    test_that("Valid request", {

      expect_POST(
        upload_file(file = "test",
                     workspace_uuid = "test_workspace"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents ",
               "Multipart form:\n  ",
               "name = test\n  ",
               "workspaceUuid = test_workspace\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

      expect_POST(
        upload_file(file = "test",
                     name = "test_file_name",
                     workspace_uuid = "test_workspace"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/documents ",
               "Multipart form:\n  ",
               "name = test_file_name\n  ",
               "workspaceUuid = test_workspace\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

      expect_POST(
        new_version(file = "test",
                             document_uuid = "test_asset"),
        paste0("https://secure.objectiveconnect.co.uk/publicapi/1/",
               "documents/test_asset/upload ",
               "Multipart form:", "\n  ",
               "file = File: d41d8cd98f00b204e9800998ecf8427e")
      )

    })

  })


  with_mock_api({

    with_envvar(

      new = c("OBJR_USR" = "test_usr",
              "OBJR_PWD" = "test_pwd"),

      code = {

        test_that("Function returns invisible", {

          expect_invisible(
            suppressMessages(new_version(file = "test",
                                                  document_uuid = "test_asset"))
          )

          expect_invisible(
            suppressMessages(upload_file(file = "test",
                                          workspace_uuid = "test_workspace"))
          )

        })

        test_that("Function returns success message", {

          expect_message(new_version(file = "test",
                                              document_uuid = "test_asset"))

        })

      })

  })

})
