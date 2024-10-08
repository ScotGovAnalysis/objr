#' Get data frame of assets in workspace
#'
#' @param workspace_uuid UUID of workspace
#' @param type List of asset types to return. Defaults to all types;
#' document, folder and link.
#' @param page Page number of responses to return (0..N).
#' @param size Number of results to be returned per page.
#' @inheritParams objr
#'
#' @return Data frame
#'
#' @export

assets <- function(workspace_uuid,
                   type = list("document", "folder", "link"),
                   page = NULL,
                   size = NULL,
                   use_proxy = FALSE) {

  check_list(type)

  type <- paste(toupper(type), collapse = "|")

  response <- objr(
    endpoint = "assets",
    url_query = list(workspaceUuid = workspace_uuid,
                     type = type,
                     page = page,
                     size = size),
    use_proxy = use_proxy
  )

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(\(x) data.frame(asset_info_list(x)))

  Reduce(dplyr::bind_rows, content)

}


#' Get asset information
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objr
#'
#' @return Named list containing: uuid, name, type, extension, description.
#'
#' @export

asset_info <- function(asset_uuid,
                       use_proxy = FALSE) {

  response <- objr(
    endpoint = "assets",
    url_path = list(asset_uuid),
    use_proxy = use_proxy
  ) |>
    httr2::resp_body_json()

  asset_info_list(response)

}


#' Delete an asset
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objr
#'
#' @details Note: Note: This functionality is disabled in Scottish Government
#' workspaces.
#'
#' @export

delete_asset <- function(asset_uuid,
                         use_proxy = FALSE) {

  response <- objr(
    endpoint = "assets",
    method = "DELETE",
    url_path = list(asset_uuid),
    use_proxy = use_proxy
  ) |>
    httr2::resp_body_json()

  if (tolower(response$status) == "complete") {
    cli::cli_alert_success("Asset deleted: {asset_uuid}.")
  }

  invisible(response)

}


#' Rename an asset
#'
#' @param asset_uuid UUID of asset
#' @param new_name Character. New name to give asset.
#' @inheritParams objr
#'
#' @export

rename_asset <- function(asset_uuid,
                         new_name,
                         use_proxy = FALSE) {

  response <- objr(
    endpoint = "assets",
    method = "PUT",
    accept = "*/*",
    url_path = list(asset_uuid, "name"),
    body = list(name = new_name),
    use_proxy = use_proxy
  )

  if (response$status_code == 204) {
    cli::cli_alert_success("Asset renamed to {.val new_name}: {asset_uuid}.")
  }

  invisible(response)

}


na_if_null <- function(x) {
  if (is.null(x)) NA else x
}

asset_info_list <- function(x) {

  list(
    asset_name       = x$name,
    asset_ext        = na_if_null(x$extension),
    asset_type       = x$type,
    asset_uuid       = x$uuid,
    last_modified_by = paste(na_if_null(x[["modifiedBy"]]$givenName),
                             na_if_null(x[["modifiedBy"]]$familyName)),
    last_modified    = na_if_null(convert_from_epoch(x$modifiedTime)),
    latest_version   = na_if_null(x$contentVersion),
    parent_name      = na_if_null(x[["parent"]]$name),
    parent_uuid      = na_if_null(x[["parent"]]$uuid),
    workspace_name   = x[["workspace"]]$name,
    workspace_uuid   = x[["workspace"]]$uuid
  )

}
