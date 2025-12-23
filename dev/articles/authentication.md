# Authentication

## How authentication works

The first time you send a request, the API requires your Objective
Connect user email address and password to authenticate.

Each successful response from the API includes a token. This token can
then be used to authenticate subsequent requests in your session,
negating the need to repeatedly supply your email address and password.

Depending on your account and/or workspace settings, you may also be
required to use two-factor or mobile authentication.

The rest of this article details how to manage authentication when using
the `objr` package.

## First request

You will need your Objective Connect user email address and password to
make a first request to the API. These can be provided in two ways.

### R Environment variables

Add two variables to your `.Renviron` file to define your email address
and password.

- Open your `.Renviron` file to edit:

  ``` r
  usethis::edit_r_environ()
  ```

- Add two variables as follows (replacing `XXX` with your credentials):

  ``` r
  OBJR_USR = "XXX"
  OBJR_PWD = "XXX"
  ```

- Save and close the `.Renviron` file.

- To check this has worked as expected, first restart your R session
  then run:

  ``` r
  Sys.getenv("OBJR_USR")
  Sys.getenv("OBJR_PWD")
  ```

  Your credentials should be printed in the console.

  Note: It is important not to save your R session workspace on close as
  your console may contain your Objective Connect credentials.

The benefit of this method is that you can leave this information in
your `.Renviron` file and `objr` will automatically find them here each
time you use the package.

### Supply credentials when prompted

If you don’t have these variables defined in your `.Renviron` file,
`objr` will prompt you to supply them if you’re working in an
interactive session.

![A small pop-up window with prompt 'Enter email registered with
Objective Connect' followed by a text input box and buttons to select
'OK' or 'Cancel'.](auth_prompt.png)

## Subsequent requests

Each successful API response includes a token that can be used for
subsequent requests. `objr` functions automatically parse this token
from the API response and store it in your R session’s global
environment (as `token`).

Where this object exists, `objr` will automatically use it to
authenticate subsequent requests.

If this object doesn’t exist, `objr` will resort to using your username
and password, as it did for your [first request](#first-request).

### Token expiry

Tokens expire when they have been unused for 20 minutes or more. You can
see the expiry time of your current token by viewing `token$expiry`.

If you try to make a request with an expired token in your environment,
it will be removed, and `objr` will try to use your username and
password instead.

Note that if you are using [mobile authentication](#mobileauth), this
will still fail, and you should login again using
[`mobile_auth_login()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_login.md)
to generate a new token.

## Multi-factor authentication

### Two-factor authentication

Two-factor authentication (2FA) may be enforced in some workspaces. When
using Objective Connect in your browser, this means you will need to
enter a code that has been emailed to you before completing certain
tasks.

To use `objr` in these workspaces, users must be given permission to
bypass 2FA. More information and guidance to set this up is available in
the [Two-factor authentication
article](https://ScotGovAnalysis.github.io/objr/dev/articles/two-factor.md).

### Mobile authentication

Mobile authentication may be enforced in some workspaces, or you may
have enabled this yourself. [Guidance to enable, register or disable
mobile
authentication](https://helpdocs.objective.com/objectiveconnect/K_AdminFunctions/ManagingMobileAuth.htm)
is available in the Objective Connect Help documentation.

You can view the status of mobile authentication on your account using
[`mobile_auth_status()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_status.md).
For example:

``` r
mobile_auth_status()
```

    ## $mobileAuthLogin
    ## [1] TRUE
    ## 
    ## $mobileAuthRegistered
    ## [1] TRUE

If you have both enabled mobile authentication and registered a mobile
device, you will need to login using mobile authentication before using
any other `objr` functionality. This can be done using
[`mobile_auth_login()`](https://ScotGovAnalysis.github.io/objr/dev/reference/mobile_auth_login.md).
This function requires [username and password
authentication](#first-request) as with any other first request.

You can either provide the authentication code from your mobile device
directly to the function:

``` r
mobile_auth_login("123456")
```

Or, if left empty, you will be prompted to enter your code in a pop-up
window:

``` r
mobile_auth_login()
```

![A small pop-up window with prompt 'Enter mobile authentication code'
followed by a text input box and buttons to select 'OK' or
'Cancel'.](mobileauth_prompt.png)

    ## ✔ Successfully logged in via Mobile Authenticator.

If login is successful, the token from the API response is stored
automatically and used for [subsequent requests](#subsequent-requests).
[Tokens expire](#token-expiry) when they have been unused for 20 minutes
or more - if this happens, you will need to login using your mobile
authenticator again.

Mobile authentication login attempts are limited to a maximum of 5
failures within a 5-minute interval. After 5 failed attempts, your
Objective Connect account will be locked. To regain access, wait for 5
mins and then try logging in again.
