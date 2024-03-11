# Create folder with parent

structure(
  list(method = "POST",
       url = "https://api/folders",
       status_code = 200L,
       headers = structure(list(
         Date = "Mon, 11 Mar 2024 09:48:47 GMT",
         `Content-Type` = "application/json", `Transfer-Encoding` = "chunked",
         Connection = "keep-alive", `X-CONNECT-MDC` = "apiJLhPQrEH",
         `X-Frame-Options` = "deny", `X-XSS-Protection` = "1; mode=block",
         `Cache-Control` = "no-cache, no-store", Expires = "0",
         Pragma = "no-cache", `Strict-Transport-Security` = "max-age=31536000 ; includeSubDomains",
         `Content-Security-Policy` = "script-src 'self' 'unsafe-inline'",
         `X-Content-Type-Options` = "nosniff", `Referrer-Policy` = "strict-origin-when-cross-origin",
         `Feature-Policy` = "vibrate 'none'; geolocation 'none'",
         Authorization = "REDACTED", `Set-Cookie` = "REDACTED"), class = "httr2_headers"),
       body = charToRaw("{\"model\":\"Asset\",\"uuid\":\"test_folder_uuid\",\"name\":\"test_folder_name\",\"workspaceUuid\":\"test_workspace\",\"type\":\"FOLDER\",\"modifiedByUuid\":\"test_user\",\"status\":\"COMPLETE\",\"parentUuid\":\"test_parent\"}"),
       cache = new.env(parent = emptyenv())),
  class = "httr2_response")
