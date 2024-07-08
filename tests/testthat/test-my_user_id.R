with_mock_api({

  with_envvar(

    new = c("OBJR_USR" = "test_usr",
            "OBJR_PWD" = "test_pwd"),

    code = {

      test_that("Valid response", {
        user <- my_user_id()
        expect_equal(user, "1234")
      })

    })

})
