#' Set OBJECTIVER_PROXY environment variable
#'
#' @param proxy_url Character value. If NULL, user will be prompted to enter.
#' @param overwrite Logical to indicate whether to overwrite variable if it
#' already exists.
#'
#' @examples \dontrun{set_proxy()}
#'
#' @export

set_proxy <- function(proxy_url = NULL, overwrite = FALSE) {

  # Validate supplied value or prompt if not supplied
  proxy_url <- valid_input("proxy", proxy_url)

  # Check if env variable already exists
  exists <-
    !is.null(Sys.getenv("OBJECTIVER_PROXY")) &&
    (Sys.getenv("OBJECTIVER_PROXY") != "")

  if (exists && !overwrite) {
    cli::cli_abort(
      c("x" = "OBJECTIVER_PROXY already exists as environment variable.",
        "i" = "To overwrite, set `overwrite = TRUE`."),
      class = "objectiveR_proxy-exists"
    )
  }

  Sys.setenv("OBJECTIVER_PROXY" = proxy_url)

  cli::cli_alert_info("Environment variable set: OBJECTIVER_PROXY")

}


#' Get OBJECTIVER_PROXY environment variable
#'
#' @return Value of OBJECTIVER_PROXY environment variable
#'
#' @examples \dontrun{get_proxy()}
#'
#' @export

get_proxy <- function() {

  proxy_url <- Sys.getenv("OBJECTIVER_PROXY")

  if (is.null(proxy_url) || proxy_url == "") {
    cli::cli_abort(
      c("x" = "OBJECTIVER_PROXY not found.",
        "i" = paste("Set proxy using ",
                    "{.help [{.fun set_proxy}](objectiveR::set_proxy)}")),
      class = "objectiveR_no-proxy-exists"
    )
  }

  proxy_url

}
