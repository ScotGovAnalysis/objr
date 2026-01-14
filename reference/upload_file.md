# Upload a file

- Use `upload_file()` to create a new file in a workspace.

- Use `upload_file_version()` to create a new version of an existing
  document.

## Usage

``` r
upload_file(
  file,
  uuid,
  name = NULL,
  description = NULL,
  parent_uuid = NULL,
  use_proxy = FALSE
)

upload_file_version(file, uuid, use_proxy = FALSE)
```

## Arguments

- file:

  File path of document to upload

- uuid:

  For `upload_file()`, a workspace UUID to create the new document in.
  For `upload_file_version()`, an asset UUID to create a new version of.

- name:

  Name to give document. If this isn't provided, the name of the file
  will be used.

- description:

  Optional description of document.

- parent_uuid:

  UUID of folder in the workspace to create the new document within. If
  not supplied, the document will be created in the top-level of the
  workspace.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

More details on the endpoints used by these functions are available in
the API documentation:

- [`upload_file`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/createDocument)

- [`upload_file_version`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/createDocumentVersion_1)

## See also

Other Read/write functions:
[`download_file()`](https://ScotGovAnalysis.github.io/objr/reference/download_file.md),
[`read_data()`](https://ScotGovAnalysis.github.io/objr/reference/read_data.md),
[`write_data()`](https://ScotGovAnalysis.github.io/objr/reference/write_data.md)
