#' Get data frame of document versions
#'
#' @param document_uuid UUID of document (asset)
#' @inheritParams objr
#' @inheritParams workspaces
#'
#' @return Data frame
#'
#' @export

versions <- function(document_uuid,
                     page = NULL,
                     size = NULL,
                     use_proxy = FALSE) {

  response <- objr(
    endpoint = "documentversions",
    url_query = list(documentUuid = document_uuid,
                     page = page,
                     size = size),
    use_proxy = use_proxy
  )

  dplyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    tidyr::hoist(
      .data$content,
      asset_name = c("asset", "name"),
      asset_ext = "extension",
      asset_uuid = c("asset", "uuid"),
      version = "version",
      version_uuid = "uuid",
      created_date = "createdTime",
      name1 = c("createdBy", "givenName"),
      name2 = c("createdBy", "familyName"),
      workspace_name = c("asset", "workspace", "name"),
      workspace_uuid = c("asset", "workspace", "uuid"),
      .transform = list(created_date = convert_from_epoch)
    ) %>%
    dplyr::mutate(created_by = paste(.data$name1, .data$name2),
                  .after = "created_date") %>%
    dplyr::select(-c("name1", "name2", "content"))

}


#' Rollback a document to a previous version
#'
#' @param document_uuid UUID of document (asset)
#' @param version_uuid UUID of version to rollback to
#' @inheritParams objr
#'
#' @export

rollback_to_version <- function(document_uuid,
                                version_uuid,
                                use_proxy = FALSE) {

  response <- objr(
    endpoint = "documents",
    method = "PUT",
    url_path = list(document_uuid, "rollback"),
    body = list(targetVersionUuid = version_uuid),
    use_proxy = use_proxy
  )

  if (response$status_code == 204) {
    cli::cli_alert_success("Document rollback successful.")
  }

  invisible(response)

}
