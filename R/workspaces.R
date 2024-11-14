#' Get workspaces the current user is a member of
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Workspaces/getMyWorkspaces}{API documentation}.
# nolint end
#'
#' @param workgroup_uuid UUID of workgroup to filter by
#' @param page Page number of responses to return (0..N). Default is 0.
#' @param size Number of results to be returned per page. Default is 20.
#' @inheritParams objr
#'
#' @return Data frame
#'
#' @export

workspaces <- function(workgroup_uuid = NULL,
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

  dplyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    tidyr::hoist(
      .data$content,
      workspace_name   = "name",
      workspace_uuid   = "uuid",
      participant_uuid = c("participant", "uuid"),
      name1            = c("owner", "givenName"),
      name2            = c("owner", "familyName"),
      owner_email      = c("owner", "email"),
      owner_uuid       = c("owner", "uuid"),
      workgroup_name   = c("workgroup", "name"),
      workgroup_uuid   = c("workgroup", "uuid")
    ) %>%
    dplyr::mutate(owner_name = paste(.data$name1, .data$name2),
                  .before = "owner_email") %>%
    dplyr::select(-c("name1", "name2", "content"))

}
