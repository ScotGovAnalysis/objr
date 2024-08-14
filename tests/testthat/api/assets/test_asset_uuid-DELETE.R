structure(list(method = "POST", url = "https://api/assets/test_asset_uuid",
  status_code = 200L, headers = structure(list(
    Date = "Tue, 09 Apr 2024 13:20:11 GMT",
    `Content-Type` = "application/json", `Transfer-Encoding` = "chunked",
    Connection = "keep-alive", `X-CONNECT-MDC` = "apisyjgCiSS",
    `X-Frame-Options` = "deny", `X-XSS-Protection` = "1; mode=block",
    `Cache-Control` = "no-cache, no-store", Expires = "0",
    Pragma = "no-cache", `Strict-Transport-Security` = "max-age=31536000 ; includeSubDomains",
    `Content-Security-Policy` = "script-src 'self' 'unsafe-inline'",
    `X-Content-Type-Options` = "nosniff", `Referrer-Policy` = "strict-origin-when-cross-origin",
    `Feature-Policy` = "vibrate 'none'; geolocation 'none'",
    Authorization = "REDACTED", `Set-Cookie` = "REDACTED"), class = "httr2_headers"),
  body = charToRaw("{\"model\":[\"Asset\"],\"uuid\":[\"test_asset_uuid\"],\"status\":[\"COMPLETE\"]}"),
  cache = new.env(parent = emptyenv())), class = "httr2_response")
