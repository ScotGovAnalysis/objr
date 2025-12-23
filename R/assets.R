#' Get data frame of assets in workspace
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/getAssets}{API documentation}.
# nolint end
#'
#' @param workspace_uuid UUID of workspace
#' @param type List of asset types to return. Default returns all types;
#' "document", "folder" and "link".
#'
#' List must be empty (default, returns all asset types), or length 1 (e.g.
#' `list("document")`). This is a temporary measure while a bug in the
#' underlying API is outstanding (see
#' [objr#53](https://github.com/ScotGovAnalysis/objr/issues/53)).
#'
#' @inheritParams objr
#' @inheritParams workspaces
#'
#' @return A tibble
#'
#' @family Asset functions
#'
#' @export

assets <- function(workspace_uuid,
                   type = list(),
                   page = NULL,
                   size = NULL,
                   use_proxy = FALSE) {

  check_list(type)

  if (length(type) > 1) {
    cli::cli_abort(c(
      "x" = "{.arg type} must be a list of length 0 or 1, not {length(type)}.",
      "i" = paste(
        "There is currently a bug in the underlying API preventing",
        "users from selecting more than one asset type. See",
        "{.href [objr#53](https://github.com/ScotGovAnalysis/objr/issues/53)}",
        "for more information."),
      "i" = paste("To return all assets, use `type = list()` (default)."),
      "i" = paste("To return one asset type only, e.g. documents, use",
                  "`type = list(\"document\")`. See `?assets` for all",
                  "options.")
    ))
  }

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
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/getAssetByUuid}{API documentation}.
# nolint end
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objr
#'
#' @return A tibble
#'
#' @family Asset functions
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
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/deleteAsset}{API documentation}.
# nolint end
#'
#' Note: This functionality is disabled in Scottish Government workspaces.
#'
#' @param asset_uuid UUID of asset
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @family Asset functions
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
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/updateAssetName}{API documentation}.
# nolint end
#'
#' @param asset_uuid UUID of asset
#' @param new_name Character. New name to give asset.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @family Asset functions
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
