#' Download a file and save to disk
#'
#' @param document_uuid UUID of existing document
#' @param folder Folder to save downloaded file to
#' @inheritParams objr
#'
#' @return An httr2 [httr2::response()][response] (invisibly)
#'
#' @export

download_file <- function(document_uuid,
                          folder,
                          use_proxy = FALSE) {

  doc_info <- asset_info(document_uuid)

  path <- file.path(folder, paste0(doc_info$asset_name, ".",
                                   doc_info$asset_ext))

  file.create(path)

  response <- objr(
    endpoint = "documents",
    url_path = list(document_uuid, "download"),
    method = "GET",
    path = path,
    use_proxy = use_proxy
  )

  if(httr2::resp_status(response) == 200) {
    cli::cli_alert_success("File downloaded: {path}.")
  }

  invisible(response)

}


#' Read a data file into R
#'
#' @param document_uuid UUID of existing document
#' @param ... Additional arguments to pass to read function. See details.
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
#' If there are other data file types you would like to download using this
#' function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
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
