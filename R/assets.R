#' Get data frame of workspace assets
#'
#' @param workspace_uuid UUID of workspace
#' @param type List of asset types to return. Defaults to all types;
#' document, folder and link.
#' @param page Page number of responses to return (0..N).
#' @param size Number of results to be returned per page.
#' @inheritParams objectiveR
#'
#' @return Data frame
#'
#' @export

workspace_assets <- function(workspace_uuid,
                             type = list("document", "folder", "link"),
                             page = NULL,
                             size = NULL,
                             use_proxy = FALSE) {

  # Check list supplied (better way to do this)
  stopifnot(
    "`type` must be a list" = class(type) %in% c("NULL", "list")
  )

  type <- paste(toupper(type), collapse = "|")

  response <- objectiveR(
    endpoint = "assets",
    url_query = list(workspaceUuid = workspace_uuid,
                     type = type,
                     page = page,
                     size = size)
  )

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(
      \(content) {
        content$workspace <- NULL
        content$modifiedBy <- NULL
        data.frame(content)
      }
    )

  Reduce(dplyr::bind_rows, content)

}


#' Get asset information
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objectiveR
#'
#' @return Named list containing: uuid, name, type, extension, description.
#'
#' @export

asset_info <- function(asset_uuid,
                       use_proxy = FALSE) {

  response <- objectiveR(
    endpoint = "assets",
    url_path = list(asset_uuid),
    use_proxy = use_proxy
  ) |>
    httr2::resp_body_json()

  # Return useful information as list
  response[c("uuid", "name", "type", "extension", "description")]

}
