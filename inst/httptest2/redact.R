function(response) {

  response["request"] <- NULL

  response |>
    gsub_response("secure.objectiveconnect.co.uk/publicapi/1/", "api/") |>
    redact_headers(headers = c("Authorization")) |>
    redact_cookies()

}
