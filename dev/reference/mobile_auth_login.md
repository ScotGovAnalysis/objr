# Login using mobile authenticator

Login using mobile authenticator

## Usage

``` r
mobile_auth_login(code = NULL, use_proxy = FALSE)
```

## Arguments

- code:

  Character string. Time-based one time-password from mobile
  authenticator. If not supplied, a pop-up window will prompt the user
  to enter.

- use_proxy:

  Logical to indicate whether to use proxy.

## Value

API response (invisibly)

## Details

Mobile authenticator login attempts are limited to a maximum of 5
failures within a 5-minute interval. After 5 failed attempts, your
Objective Connect account will be locked. To regain access, wait for 5
mins and then try logging in again.

More information on mobile authentication can be found in
[`vignette("authentication")`](https://ScotGovAnalysis.github.io/objr/dev/articles/authentication.md).

More details on this endpoint are available in the [API
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html?configUrl=/publicapi/1/v3/api-docs/swagger-config#/MobileAuth/login).

## See also

Other Mobile authentication functions:
[`mobile_auth_status()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_status.md)
