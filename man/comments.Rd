% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/comments.R
\name{comments}
\alias{comments}
\title{Get comments for workspaces of current user}
\usage{
comments(
  created_after = NULL,
  thread_uuid = NULL,
  mention_uuid = NULL,
  workgroup_uuid = NULL,
  page = NULL,
  size = NULL,
  use_proxy = FALSE
)
}
\arguments{
\item{created_after}{Date (and optionally time) to filter comments created
since this date/time. If a time is not supplied, all comments made on this
day will be included.}

\item{thread_uuid}{UUID of thread to filter by}

\item{mention_uuid}{UUID of user to filter comments where mentioned}

\item{workgroup_uuid}{UUID of workgroup to filter by}

\item{page}{Page number of responses to return (0..N).}

\item{size}{Number of results to be returned per page.}

\item{use_proxy}{Logical to indicate whether to use proxy}
}
\value{
Data frame
}
\description{
Get comments for workspaces of current user
}
\examples{
\dontrun{
comments()
}

}
