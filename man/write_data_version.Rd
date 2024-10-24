% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/upload.R
\name{write_data_version}
\alias{write_data_version}
\title{Write a data file from R to create a new document version}
\usage{
write_data_version(x, document_uuid, ..., use_proxy = FALSE)
}
\arguments{
\item{x}{R object to write to file.}

\item{document_uuid}{UUID of existing document}

\item{...}{Additional arguments to pass to write function. See details.}

\item{use_proxy}{Logical to indicate whether to use proxy}
}
\value{
An httr2 \link[=response]{httr2::response()} (invisibly)
}
\description{
Write a data file from R to create a new document version
}
\details{
This function can be used to write the following data file types:
csv, rds, xlsx. The file type used is determined by the file type of the
existing document.

The function works by writing the R object to a temporary file and uploading
the file to Objective Connect. The following functions are used to
write the data and any additional arguments (\code{...}) will be passed to these.\tabular{ll}{
   File Type \tab Function \cr
   csv \tab \code{readr::write_csv()} \cr
   rds \tab \code{readr::write_rds()} \cr
   xlsx \tab \code{writexl::write_xlsx()} \cr
}


If there are other data file types you would like to upload using this
function, please \href{https://github.com/ScotGovAnalysis/objr/issues/new}{open an issue on the GitHub repository}.
}
