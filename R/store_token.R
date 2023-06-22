#' Store session token from API response
#'
#' @param response An httr2 response object; must contain an 'Authorization'
#' header.
#' @param store_env The environment to bind the token to.
#'
#' @return Returns the token invisibly. This function is primarily used
#' for its side effect - an environment variable is created called "token".

store_token <- function(response, store_env = parent.frame()) {

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

  token <- httr2::resp_header(response, "Authorization")

  if(!exists("token", where = store_env)) {
    rlang::env_poke(env = store_env, nm = "token", value = token)
  }

  return(invisible(token))

}
