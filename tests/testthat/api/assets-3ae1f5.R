# type = folder

structure(list(method = "GET", url = "https://api/assets?workspaceUuid=test_workspace&type=DOCUMENT%7CFOLDER%7CLINK",
    status_code = 200L, headers = structure(list(Date = "Mon, 08 Apr 2024 16:12:59 GMT",
        `Content-Type` = "application/json", `Transfer-Encoding` = "chunked",
        Connection = "keep-alive", `X-CONNECT-MDC` = "apiGMsONBfA",
        `X-Frame-Options` = "deny", `X-XSS-Protection` = "1; mode=block",
        `Cache-Control` = "no-cache, no-store", Expires = "0",
        Pragma = "no-cache", `Strict-Transport-Security` = "max-age=31536000 ; includeSubDomains",
        `Content-Security-Policy` = "script-src 'self' 'unsafe-inline'",
        `X-Content-Type-Options` = "nosniff", `Referrer-Policy` = "strict-origin-when-cross-origin",
        `Feature-Policy` = "vibrate 'none'; geolocation 'none'",
        Authorization = "REDACTED", `Set-Cookie` = "REDACTED"), class = "httr2_headers"),
    body = charToRaw("{\"content\":[{\"uuid\":\"test_asset_uuid\",\"name\":\"test_asset_name\",\"type\":\"FOLDER\",\"workspace\":{\"uuid\":\"test_workspace_uuid\",\"name\":\"test_workspace_name\"},\"modifiedBy\":{\"givenName\":\"test_modified_name1\",\"familyName\":\"test_modified_name2\"}}],\"metadata\":{\"totalElements\":1,\"totalPages\":1,\"page\":0,\"offset\":0}}"),
    cache = new.env(parent = emptyenv())), class = "httr2_response")
