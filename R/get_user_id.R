#' Get user ID for current authenticated user
#'
#' @param use_proxy Logical; to indicate whether proxy required.
#'
#' @return A character value of the authenticated user's ID
#'
#' @export

my_user_id <- function(use_proxy = FALSE) {

  response <- objectiveR("me", use_proxy = use_proxy)

  response$uuid

}
