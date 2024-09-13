#' Upload a file to create a new document
#'
#' @param file File path of document to upload
#' @param name Name to give document. If this isn't provided, the name of the
#' file will be used.
#' @param workspace_uuid UUID of the workspace to create the new document in
#' @param description Optional description of document.
#' @param parent_uuid UUID of folder in the workspace to create the new
#' document within. If not supplied, the document will be created in the
#' top-level of the workspace.
#' @inheritParams objr
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

upload_file <- function(file,
                        workspace_uuid,
                        name = NULL,
                        description = NULL,
                        parent_uuid = NULL,
                        use_proxy = FALSE) {

  check_file_exists(file)

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

upload_file_version <- function(file,
                                document_uuid,
                                use_proxy = FALSE) {

  check_file_exists(file)

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


#' Write a data file from R to create a new document
#'
#' @param x R object to write to file.
#' @param file_name Name to give file.
#' @param file_type Either "csv", "rds" or "xlsx".
#' @param ... Additional arguments to pass to write function. See details.
#' @inheritParams objr
#' @inheritParams upload_file
#'
#' @details This function can be used to write the following data file types:
#' csv, rds, xlsx. Use the \code{file_type} argument to control which file type
#' to create.
#'
#' The function works by writing the R object to a temporary file and uploading
#' the file to Objective Connect. The following functions are used to
#' write the data and any additional arguments (`...`) will be passed to these.
#'
#' | File Type | Function |
#' | --- | --- |
#' | csv | \code{readr::write_csv()} |
#' | rds | \code{readr::write_rds()} |
#' | xlsx | \code{writexl::write_xlsx()} |
#'
#' If there are other data file types you would like to upload using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

write_data <- function(x,
                       file_name,
                       file_type,
                       workspace_uuid,
                       ...,
                       description = NULL,
                       parent_uuid = NULL,
                       use_proxy = FALSE) {

  # Write data to temporaty file
  path <- write_temp(x, file_name = file_name, file_type = file_type, ...)

  # Delete temp file when exiting function
  on.exit(unlink(path), add = TRUE)

  resp <- upload_file(path,
                      workspace_uuid = workspace_uuid,
                      description = description,
                      parent_uuid = parent_uuid,
                      use_proxy = FALSE)

  invisible(resp)

}


#' Write a data file from R to create a new document version
#'
#' @param x R object to write to file.
#' @param ... Additional arguments to pass to write function. See details.
#' @inheritParams objr
#' @inheritParams upload_file_version
#'
#' @details This function can be used to write the following data file types:
#' csv, rds, xlsx. The file type used is determined by the file type of the
#' existing document.
#'
#' The function works by writing the R object to a temporary file and uploading
#' the file to Objective Connect. The following functions are used to
#' write the data and any additional arguments (`...`) will be passed to these.
#'
#' | File Type | Function |
#' | --- | --- |
#' | csv | \code{readr::write_csv()} |
#' | rds | \code{readr::write_rds()} |
#' | xlsx | \code{writexl::write_xlsx()} |
#'
#' If there are other data file types you would like to upload using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

write_data_version <- function(x,
                               document_uuid,
                               ...,
                               use_proxy = FALSE) {

  # Get asset info
  info <- asset_info(document_uuid)

  path <- write_temp(x,
                     file_name = info$name,
                     file_type = info$extension,
                     ...)

  # Delete temp file when exiting function
  on.exit(unlink(path), add = TRUE)

  resp <- upload_file_version(path,
                              document_uuid,
                              use_proxy = use_proxy)

  invisible(resp)

}
