#' Get data frame of assets in workspace
#'
#' @param workspace_uuid UUID of workspace
#' @param type List of asset types to return. Defaults to all types;
#' document, folder and link.
#' @param page Page number of responses to return (0..N).
#' @param size Number of results to be returned per page.
#' @inheritParams objr
#'
#' @return Tibble
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

  tidyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    asset_info_list()

}


#' Get asset information
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objr
#'
#' @return Tibble
#'
#' @export

asset_info <- function(asset_uuid,
                       use_proxy = FALSE) {

  response <- objr(
    endpoint = "assets",
    url_path = list(asset_uuid),
    use_proxy = use_proxy
  ) %>%
    httr2::resp_body_json()

  dplyr::tibble(content = list(response)) %>%
    asset_info_list()

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
  ) %>%
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

asset_info_list <- function(x) {

  tidyr::hoist(
    x,
    .data$content,
    asset_name       = "name",
    asset_ext        = "extension",
    asset_type       = "type",
    asset_uuid       = "uuid",
    name1            = c("modifiedBy", "givenName"),
    name2            = c("modifiedBy", "familyName"),
    last_modified    = "modifiedTime",
    latest_version   = "contentVersion",
    parent_name      = c("parent", "name"),
    parent_uuid      = c("parent", "uuid"),
    workspace_name   = c("workspace", "name"),
    workspace_uuid   = c("workspace", "uuid"),
    .transform = list(last_modified = convert_from_epoch)
  ) %>%
    dplyr::mutate(last_modified_by = paste(.data$name1, .data$name2),
                  .after = "last_modified") %>%
    dplyr::select(-c("name1", "name2", "content"))

}
