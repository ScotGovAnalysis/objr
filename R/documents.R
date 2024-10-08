#' Get data frame of document versions
#'
#' @param document_uuid UUID of document (asset)
#' @param page Page number of responses to return (0..N).
#' @param size Number of results to be returned per page.
#' @inheritParams objr
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

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(\(x) data.frame(versions_info_list(x)))

  Reduce(dplyr::bind_rows, content)

}


versions_info_list <- function(x) {

  list(
    asset_name       = x[["asset"]]$name,
    asset_ext        = na_if_null(x$extension),
    asset_uuid       = x[["asset"]]$uuid,
    version          = x$version,
    version_uuid     = x$uuid,
    created_date     = na_if_null(convert_from_epoch(x$createdTime)),
    created_by       = paste(na_if_null(x[["createdBy"]]$givenName),
                             na_if_null(x[["createdBy"]]$familyName)),
    workspace_name   = x[["asset"]][["workspace"]]$name,
    workspace_uuid   = x[["asset"]][["workspace"]]$uuid
  )

}
