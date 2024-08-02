library(httptest2)
library(withr)

withr::local_envvar(
  .new = list("OBJR_USR" = "test_usr",
              "OBJR_PWD" = "test_pwd",
              "OBJR_PROXY" = "test_proxy"),
  .local_envir = teardown_env()
)
