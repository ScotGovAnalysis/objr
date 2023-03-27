#' Store bearer token from API response
#'
#' @param response An httr2 response object; must contain an 'Authorization'
#' header.
#' @param store_env The environment to bind the bearer token to. Defaults to
#' the global environment.
#'
#' @return Returns the bearer token invisibly. This function is primarily used
#' for its side effect - an environment variable is created called "bearer".

store_bearer <- function(response, store_env = .GlobalEnv) {

  # Check request is in expected format
  if(!inherits(response, "httr2_response")) {
    cli::cli_abort(c(
      "x" = "{.var response} must be an HTTP response object"
    ))
  }

  # Check Authorization header exists
  if(!httr2::resp_header_exists(response, "Authorization")) {
    cli::cli_abort(c(
      "x" = "{.var response} must have Authorization header"
    ))
  }

  token <- gsub("bearer ", "", httr2::resp_header(response, "Authorization"))

  rlang::env_poke(env = store_env, nm = "bearer", value = token)

  return(invisible(token))

}
