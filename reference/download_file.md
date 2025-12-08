# Download a file and save to disk

- Use `download_file()` with an asset UUID for the latest version of a
  document.

- Use `download_file_version()` with a document version UUID for a
  specific version of a document.

## Usage

``` r
download_file(document_uuid, folder, overwrite = FALSE, use_proxy = FALSE)

download_file_version(
  document_uuid,
  folder,
  overwrite = FALSE,
  use_proxy = FALSE
)
```

## Arguments

- document_uuid:

  UUID of asset or document version

- folder:

  Folder to save downloaded file to

- overwrite:

  Logical to indicate whether file should be overwritten if already
  exists. Defaults to `FALSE`.

- use_proxy:

  Logical to indicate whether to use proxy

## Value

API response (invisibly)

## Details

More details on the endpoints used by these functions are available in
the API documentation:

- [`download_file`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/download)

- [`download_file_version`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/downloadVersion)
