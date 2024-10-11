#' Download a file and save to disk
#'
#' @description
#' * Use `download_file()` with an asset UUID for the latest version of a
#'   document.
#' * Use `download_file_version()` with a document version UUID for a specific
#'   version of a document.
#'
#' @param document_uuid UUID of asset or document version
#' @param folder Folder to save downloaded file to
#' @param overwrite Logical to indicate whether file should be overwritten if
#' already exists. Defaults to `FALSE`.
#' @inheritParams objr
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

download_file <- function(document_uuid,
                          folder,
                          overwrite = FALSE,
                          use_proxy = FALSE) {

  path <- create_file(folder)

  response <- objr(
    endpoint = "documents",
    url_path = list(document_uuid, "download"),
    method = "GET",
    path = path,
    use_proxy = use_proxy
  )

  new_path <- rename_file(path, response, overwrite = overwrite)

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success("File downloaded: {.path {new_path}}.")
  }

  invisible(response)

}


#' @export
#' @rdname download_file

download_file_version <- function(document_uuid,
                                  folder,
                                  overwrite = FALSE,
                                  use_proxy = FALSE) {

  path <- create_file(folder)

  response <- objr(
    endpoint = "documentversions",
    url_path = list(document_uuid, "download"),
    method = "GET",
    path = path,
    use_proxy = use_proxy
  )

  new_path <- rename_file(path, response, overwrite = overwrite)

  if (httr2::resp_status(response) == 200) {
    cli::cli_alert_success("File downloaded: {.path new_path}.")
  }

  invisible(response)

}


#' Read a data file into R
#'
#' @description
#' * Use `read_data()` with an asset UUID for the latest version of a document.
#' * Use `read_data_version()` with a document version UUID for a specific
#'   version of a document.
#'
#' @param document_uuid UUID of asset or document version
#' @param ... Additional arguments passed to read function. See details.
#' @inheritParams objr
#'
#' @details This function can be used to read the following data file types:
#' csv, rds, xlsx.
#'
#' The function works by downloading the file from Objective Connect to a
#' temporary file and reading it into R. The following functions are used to
#' read the data and any additional arguments (`...`) will be passed to these.
#'
#' | File Type | Function |
#' | --- | --- |
#' | csv | \code{readr::read_csv()} |
#' | rds | \code{readr::read_rds()} |
#' | xlsx | \code{readxl::read_xlsx()} |
#'
#' To check what file type your document is (and thus what function additional
#' arguments will be passed to), use \code{asset_info()}.
#'
# nolint start: line_length_linter
#' If there are other data file types you would like to download using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
# nolint end
#'
#' @return For csv and xlsx files, a data frame. For rds files, an R object.
#'
#' @export

read_data <- function(document_uuid,
                      ...,
                      use_proxy = FALSE) {

  resp <- suppressMessages(
    download_file(document_uuid,
                  folder = tempdir(check = TRUE),
                  use_proxy = use_proxy)
  )

  path <- resp$body[1]

  x <- read_temp(path, ...)

  unlink(path)

  x

}


#' @export
#' @rdname read_data

read_data_version <- function(document_uuid,
                              ...,
                              use_proxy = FALSE) {

  resp <- suppressMessages(
    download_file_version(document_uuid,
                          overwrite = TRUE,
                          folder = tempdir(check = TRUE),
                          use_proxy = use_proxy)
  )

  path <- file.path(tempdir(check = TRUE), file_name_from_header(resp))

  x <- read_temp(path, ...)

  unlink(path)

  x

}
