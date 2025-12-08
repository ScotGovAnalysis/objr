# Write a data file from R

- Use `write_data()` to create a new file in a workspace.

- Use `write_data_version()` to write a data file as a new version of an
  existing document.

## Usage

``` r
write_data(
  x,
  uuid,
  file_name,
  file_type,
  ...,
  description = NULL,
  parent_uuid = NULL,
  use_proxy = FALSE
)

write_data_version(x, uuid, ..., use_proxy = FALSE)
```

## Arguments

- x:

  R object to write to file.

- uuid:

  Either a workspace UUID to create a new document or an asset UUID to
  create a new version of an existing document.

- file_name:

  Name to give file.

- file_type:

  Either "csv", "rds" or "xlsx".

- ...:

  Additional arguments to pass to write function. See details.

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

This function can be used to write the following data file types: csv,
rds, xlsx. If writing to a new document, use the `file_type` argument to
control which file type to create. If writing a new version of an
existing document, the existing file type will be used.

The function works by writing the R object to a temporary file and
uploading the file to Objective Connect. The following functions are
used to write the data and any additional arguments (`...`) will be
passed to these.

|           |                                                                                         |
|-----------|-----------------------------------------------------------------------------------------|
| File Type | Function                                                                                |
| csv       | [`readr::write_csv()`](https://readr.tidyverse.org/reference/write_delim.html)          |
| rds       | [`readr::write_rds()`](https://readr.tidyverse.org/reference/read_rds.html)             |
| xlsx      | [`writexl::write_xlsx()`](https://docs.ropensci.org/writexl//reference/write_xlsx.html) |

If there are other data file types you would like to upload using this
function, please [open an issue on the GitHub
repository](https://github.com/ScotGovAnalysis/objr/issues/new).

More details on the endpoints used by these functions are available in
the API documentation:

- [`write_data`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/createDocument)

- [`write_data_version`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/createDocumentVersion_1)
