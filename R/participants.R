#' Get data frame of workspace participants
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Participants/getParticipant}{API documentation}.
# nolint end
#'
#' @param workspace_uuid UUID of workspace
#' @inheritParams objr
#'
#' @return A tibble
#'
#' @export

participants <- function(workspace_uuid, use_proxy = FALSE) {

  response <- objr(
    endpoint = "participants",
    url_query = list(workspaceUuid = workspace_uuid),
    use_proxy = use_proxy
  )

  dplyr::tibble(content = httr2::resp_body_json(response)$content) %>%
    tidyr::hoist(
      .data$content,
      name1 = c("user", "givenName"),
      name2 = c("user", "familyName"),
      user_email = c("user", "email"),
      user_uuid = "userUuid",
      participant_uuid = "uuid",
      has_accepted = "hasAccepted",
      is_owner = "isOwner",
      bypass_2fa = "bypassTwoStep",
      workspace_name = c("workspace", "name"),
      workspace_uuid = c("workspace", "uuid")
    ) %>%
    dplyr::mutate(
      user_name = dplyr::case_when(
        is.na(.data$name1) & is.na(.data$name2) ~ NA_character_,
        is.na(.data$name1) ~ .data$name2,
        is.na(.data$name2) ~ .data$name1,
        TRUE ~ paste(.data$name1, .data$name2)
      ),
      .before = 0
    ) %>%
    dplyr::select(-c("name1", "name2", "content"))

}


#' Add participant(s) to a workspace
#'
#' @details
#' More details on this endpoint are available in the
# nolint start: line_length_linter
#' \href{https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Participants/addParticipants}{API documentation}.
# nolint end
#'
#' @param workspace_uuid UUID of workspace.
#' @param emails Character vector of email addresses to send invites to.
#' @param message Optionally, a message to include in email invite.
#' @param permissions Optionally, a character vector of permissions to give
#' invited participants.
#'
#' Valid permissions are: "Download", "CreateDocument",
#' "CreateFolder", "Edit", "Delete", "EditOnline", "Inviter", "Commenter" and
#' "ManageWorkspace".
#'
#' All members are given permission to preview documents.
#' @param member_visibility Either "standard" (default) to make new participants
#' visible to all other workspace members, or "bcc" to hide participants.
#' @param send_email_invite Default `TRUE` to send an email invite for
#' participants to join the workspace. If `FALSE`, no email will be sent.
#' @inheritParams objr
#'
#' @return API response (invisibly)
#'
#' @export

add_participants <- function(workspace_uuid,
                             emails,
                             message = NULL,
                             permissions = NULL,
                             member_visibility = c("standard", "bcc"),
                             send_email_invite = TRUE,
                             use_proxy = FALSE) {

  member_visibility <- rlang::arg_match(member_visibility)

  expected_permissions <- c(
    "Download",
    "CreateDocument",
    "CreateFolder",
    "Edit",
    "Delete",
    "EditOnline",
    "Inviter",
    "Commenter",
    "ManageWorkspace"
  )

  # Check requested permissions are valid
  if (any(!permissions %in% expected_permissions)) {
    cli::cli_abort(c(
      "{.arg permissions} must only contain valid permission types.",
      "i" = paste(
        "{.str {setdiff(permissions, expected_permissions)}}",
        "{?is/are} not {?an/} accepted permission{?s}."
      ),
      "i" = paste(
        "Accepted permissions:",
        "{.str {cli::cli_vec(expected_permissions,",
        "style = list(`vec-last` = ' or '))}}."
      )
    ))
  }

  permission_values <-
    if (!is.null(permissions)) {
      rep("true", times = length(permissions)) %>%
        magrittr::set_names(paste0("has", permissions))
    } else {
      NULL
    }

  response <- objr(
    endpoint = "participants",
    method = "POST",
    body = append(
      list(
        workspaceUuid = workspace_uuid,
        emails = list(emails),
        isSilent = tolower(!send_email_invite),
        message = message,
        type = toupper(member_visibility)
      ),
      permission_values
    ),
    use_proxy = use_proxy
  )

  if (response$status == 200) {
    cli::cli_alert_success("Participant{?s} invited: {.field {emails}}.")
  }

  invisible(response)

}
