#' Get workspaces the current user is a member of
#'
#' @param workgroup_uuid UUID of workgroup to filter by
#' @param page Page number of responses to return (0..N).
#' @param size Number of results to be returned per page.
#' @inheritParams objr
#'
#' @return Data frame
#'
#' @export

my_workspaces <- function(workgroup_uuid = NULL,
                          page = NULL,
                          size = NULL,
                          use_proxy = FALSE) {

  response <- objr(
    endpoint = "myworkspaces",
    url_query = list(workgroupUuid = workgroup_uuid,
                     page = page,
                     size = size),
    use_proxy = use_proxy
  )

  content <-
    httr2::resp_body_json(response)$content |>
    lapply(
      \(content) {
        data.frame(
          workspace_name   = content$name,
          workspace_uuid   = content$uuid,
          participant_uuid = content$participant$uuid,
          owner_name       = paste(content$owner$givenName,
                                   content$owner$familyName),
          owner_email      = content$owner$email,
          owner_uuid       = content$owner$uuid,
          workgroup_name   = content$workgroup$name,
          workgroup_uuid   = content$workgroup$uuid
        )
      }
    )

  Reduce(dplyr::bind_rows, content)

}
