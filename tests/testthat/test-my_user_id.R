with_mock_api({

  withr::with_envvar(

    new = c("OBJECTIVER_USR" = "test_usr",
            "OBJECTIVER_PWD" = "test_pwd"),

    code = {

      test_that("Valid response", {
        user <- my_user_id()
        expect_equal(user, "1234")
      })

    })

})
