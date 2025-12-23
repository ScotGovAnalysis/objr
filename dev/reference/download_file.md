# Download a file and save to disk

- Use `download_file()` with an asset UUID for the latest version of a
  document.

- Use `download_file_version()` with a document version UUID for a
  specific version of a document.

## Usage

``` r
download_file(
  document_uuid,
  folder,
  file_name = NULL,
  overwrite = FALSE,
  use_proxy = FALSE
)

download_file_version(
  document_uuid,
  folder,
  file_name = NULL,
  overwrite = FALSE,
  use_proxy = FALSE
)
```

## Arguments

- document_uuid:

  UUID of asset or document version

- folder:

  Folder to save downloaded file to

- file_name:

  Optional name to give downloaded file. If not provided, file will have
  same name as Objective Connect asset.

- overwrite:

  Logical to indicate whether file should be overwritten if already
  exists. Defaults to `FALSE`.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

Path to downloaded file (invisibly).

## Details

More details on the endpoints used by these functions are available in
the API documentation:

- [`download_file`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/download)

- [`download_file_version`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/downloadVersion)

## See also

Other Read/write functions:
[`read_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/read_data.md),
[`upload_file()`](https://ScotGovAnalysis.github.io/objr/dev/reference/upload_file.md),
[`write_data()`](https://ScotGovAnalysis.github.io/objr/dev/reference/write_data.md)
