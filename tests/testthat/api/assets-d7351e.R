# All types

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
    body = charToRaw("{\"content\":[{\"model\":\"Asset\",\"uuid\":\"test_asset_1_uuid\",\"name\":\"test_asset_1_name\",\"workspaceUuid\":\"test_workspace\",\"type\":\"DOCUMENT\",\"annotationCount\":0,\"commentCount\":0,\"contentVersion\":2,\"createdTime\":1712567186000,\"modifiedTime\":1712567224000,\"extension\":\"txt\",\"fileSize\":23,\"isLocked\":false,\"isLockedInOffice\":false,\"modifiedByUuid\":\"test_modified_uuid\",\"previewStatus\":\"COMPLETED\",\"status\":\"COMPLETE\",\"mandatoryTagsPresent\":true},{\"model\":\"Asset\",\"uuid\":\"test_asset_2_uuid\",\"name\":\"test_asset_2_name\",\"workspaceUuid\":\"test_workspace\",\"type\":\"FOLDER\",\"annotationCount\":0,\"commentCount\":0,\"createdTime\":1712572827000,\"modifiedTime\":1712572827000,\"isLocked\":false,\"isLockedInOffice\":false,\"modifiedByUuid\":\"test_modified_uuid\",\"status\":\"COMPLETE\",\"mandatoryTagsPresent\":true}],\"metadata\":{\"totalElements\":[2],\"totalPages\":[1],\"page\":[0],\"offset\":[0]}}"),
    cache = new.env(parent = emptyenv())), class = "httr2_response")
