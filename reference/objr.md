# Core request function

Core request function

## Usage

``` r
objr(
  endpoint,
  url_path = NULL,
  url_query = NULL,
  method = "GET",
  body = NULL,
  path = NULL,
  accept = "application/json",
  content_type = "application/json",
  use_proxy = FALSE
)
```

## Arguments

- endpoint:

  The endpoint to append to the API server address

- url_path:

  A list of values to be added to the request URL path. Values will be
  separated with `/`.

- url_query:

  A list of named values to define query parameters

- method:

  HTTP method to use; e.g. `GET`, `POST`, `PUT`. Defaults to `GET`.

- body:

  A list of named values to be passed to the request body

- path:

  Optional file path to save body of request (mainly used when
  downloading files)

- accept:

  Accept header. Defaults to 'application/json'.

- content_type:

  Content-Type header. Defaults to 'application/json'.

- use_proxy:

  Logical to indicate whether to use proxy

## Value

API response

## Details

More details on endpoints are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/).
