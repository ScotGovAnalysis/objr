test_that("Env variable set correctly", {

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = NA),
    code = expect_no_error(set_proxy("test1"))
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = NA),
    code = expect_true({
      set_proxy("test2")
      Sys.getenv("OBJECTIVER_PROXY") == "test2"
    })
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = "test3"),
    code = expect_no_error(set_proxy("test4", overwrite = TRUE))
  )

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = "test5"),
    code = expect_true({
      set_proxy("test6", overwrite = TRUE)
      Sys.getenv("OBJECTIVER_PROXY") == "test6"
    })
  )

})

test_that("Error if env variable already exists", {

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = "test7"),
    code = {
      expect_error(set_proxy("test8"), class = "objectiveR_proxy-exists")
      expect_true(Sys.getenv("OBJECTIVER_PROXY") == "test7")
    }
  )

})

test_that("Error if no proxy env variable exists", {

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = NA),
    expect_error(get_proxy())
  )

})

test_that("Correct env variable returned", {

  withr::with_envvar(
    new = c("OBJECTIVER_PROXY" = "test9"),
    code = expect_true(get_proxy() == "test9")
  )

})
