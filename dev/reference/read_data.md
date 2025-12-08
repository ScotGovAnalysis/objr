# Read a data file into R

- Use `read_data()` with an asset UUID for the latest version of a
  document.

- Use `read_data_version()` with a document version UUID for a specific
  version of a document.

## Usage

``` r
read_data(document_uuid, ..., use_proxy = FALSE)

read_data_version(document_uuid, ..., use_proxy = FALSE)
```

## Arguments

- document_uuid:

  UUID of asset or document version

- ...:

  Additional arguments passed to read function. See details.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html).

## Details

This function can be used to read the following data file types: csv,
rds, xlsx.

The function works by downloading the file from Objective Connect to a
temporary file and reading it into R. The following functions are used
to read the data and any additional arguments (`...`) will be passed to
these.

|           |                                                                                 |
|-----------|---------------------------------------------------------------------------------|
| File Type | Function                                                                        |
| csv       | [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)    |
| rds       | [`readr::read_rds()`](https://readr.tidyverse.org/reference/read_rds.html)      |
| xlsx      | [`readxl::read_xlsx()`](https://readxl.tidyverse.org/reference/read_excel.html) |

To check what file type your document is (and thus what function
additional arguments will be passed to), use
[`asset_info()`](https://scotgovanalysis.github.io/objr/dev/reference/asset_info.md).

If there are other data file types you would like to download using this
function, please [open an issue on the GitHub
repository](https://github.com/ScotGovAnalysis/objr/issues/new).

More details on the endpoints used by these functions are available in
the API documentation:

- [`read_data`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/download)

- [`read_data_version`](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/Assets/downloadVersion)
