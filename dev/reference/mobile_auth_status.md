# Get mobile authenticator details of the current authenticated user

Get mobile authenticator details of the current authenticated user

## Usage

``` r
mobile_auth_status(use_proxy = FALSE)
```

## Arguments

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

A list object containing 2 logical values:

- `mobileAuthLogin`: Has the user enabled login via Mobile
  Authenticator?

- `mobileAuthRegistered`: Has the user registered a Mobile
  Authenticator?

## Details

More information on mobile authentication can be found in
[`vignette("authentication")`](https://scotgovanalysis.github.io/objr/dev/articles/authentication.md).

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth/getMobileAuthDetails).
