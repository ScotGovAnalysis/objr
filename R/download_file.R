#' Download file
#'
#' @param document_uuid UUID of existing document
#' @param folder Folder to save downloaded file to
#' @inheritParams objectiveR
#'
#' @export

download_file <- function(document_uuid,
                          folder,
                          use_proxy = FALSE) {

  doc_info <- asset_info(document_uuid)

  path <- file.path(folder, paste0(doc_info$name, ".", doc_info$extension))

  file.create(path)

  response <- objectiveR(
    endpoint = "documents",
    url_path = list(document_uuid, "download"),
    method = "GET",
    path = path,
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 200) {
    cli::cli_alert_success(
      "File downloaded: {path}."
    )
  }

  invisible(response)

}
