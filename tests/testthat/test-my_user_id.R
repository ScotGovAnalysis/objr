with_mock_api({

  test_that("Valid response", {
    user <- my_user_id()
    expect_equal(user, "1234")
  })

})
