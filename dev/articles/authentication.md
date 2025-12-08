# API Authentication

## How authentication works

The first time you send a request, the API requires your Objective
Connect user email address and password to authenticate.

Each successful response from the API includes a token. This token can
then be used to authenticate subsequent requests in your session,
negating the need to repeatedly supply your email address and password.

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
environment.

Where this object exists, `objr` will automatically use it to
authenticate subsequent requests.

If this object doesn’t exist, `objr` will resort to using your username
and password, as it did for your [first request](#first-request).
