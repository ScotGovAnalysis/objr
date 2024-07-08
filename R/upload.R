#' Upload a file to create a new document
#'
#' @param file File path of document to upload
#' @param name Name to give document. If this isn't provided, the name of the
#' file will be used.
#' @param workspace_uuid UUID of the workspace to create the new document in
#' @param description Optional description of document
#' @param parent_uuid UUID of folder in the workspace to create the new
#' document within. If not supplied, the document will be created in the
#' top-level of the workspace.
#' @inheritParams objr
#'
#' @export

upload_file <- function(file,
                        workspace_uuid,
                        name = NULL,
                        description = NULL,
                        parent_uuid = NULL,
                        use_proxy = FALSE) {

  # If name not provided, use file name
  name <- if(is.null(name)) {
    tools::file_path_sans_ext(basename(file))
  } else {name}

  response <- objr(
    endpoint = "documents",
    method = "POST",
    content_type = "multipart/form-data",
    body = list(
      name = curl::form_data(name),
      description = form_data_null(description),
      workspaceUuid = curl::form_data(workspace_uuid),
      parentUuid = form_data_null(parent_uuid),
      file = curl::form_file(file)
    ),
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 200) {
    cli::cli_alert_success(
      "New document created: {paste(name, tools::file_ext(file), sep = \".\")}."
    )
  }

  invisible(response)

}


#' Upload a file to create a new document version
#'
#' @param file File path of document to upload
#' @param document_uuid UUID of existing document
#' @inheritParams objr
#'
#' @export

new_version <- function(file,
                        document_uuid,
                        use_proxy = FALSE) {

  response <- objr(
    endpoint = "documents",
    url_path = list(document_uuid, "upload"),
    method = "POST",
    content_type = "multipart/form-data",
    body = list(file = curl::form_file(file)),
    use_proxy = use_proxy
  )

  # Get asset info
  info <- asset_info(document_uuid)

  if(httr2::resp_status(response) == 204) {
    cli::cli_alert_success(
      "New version created: {paste(info$name, info$extension, sep = \".\")}."
    )
  }

  invisible(response)

}
