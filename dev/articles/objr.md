# Introduction to objr

objr aims to provide a convenient method of interacting with [Objective
Connect](https://secure.objectiveconnect.co.uk) using R, making use of
the [Objective Connect
API](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html).

This article demonstrates a simple workflow for using the package, with
the ultimate aim of downloading or uploading a file to an Objective
Connect workspace.

Start by loading the package in your R session:

``` r
library(objr)
```

## Universally Unique Identifiers

It is useful to be aware that everything on Objective Connect is
associated with a Universally Unique Identifier (UUID). This includes
users, workgroups, workspaces, participants in a workspace and assets in
a workspace.

Objective Connect UUIDs take the form of a string of eight chunks of
four lower case letters and numbers, separated by dashes. For example:

    84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f

Use of the API and the objr package depends on these UUIDs. UUIDs are
mostly findable using the functions in objr (as demonstrated in this
article), however you can often also find relevant UUIDs in the webpage
URLs. For example, this is an example URL when viewing a workspace:

    https://secure.objectiveconnect.co.uk/share/2vo2-dd3s-1nn9-y20r-b906-u4s2-
    7134-b352?workgroupUuid=2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44

The UUID for the workspace is `2vo2-dd3s-1nn9-y20r-b906-u4s2-7134-b352`
and the UUID for the workgroup is
`2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44`.

## Test your authentication

To interact with the Objective Connect API, you must provide valid
authentication. This is explained in more detail in
[`vignette("authentication")`](https://scotgovanalysis.github.io/objr/dev/articles/authentication.md).

It might be a good idea to test your authentication, especially if it’s
your first time using the package. There is no specific function for
this, but the following simple function to get your own user ID requires
no input and is an easy way to test that you can get a successful
response from the API.

``` r
me <- my_user_id()
```

## Workspaces

To see workspaces you are a member of:

``` r
workspaces <- workspaces()
```

This returns a data frame with a row for each workspace you are a member
of. Among other things, there will be a column containing the workspace
name and another containing the workspace UUID. For example:

    ##   workspace_name                          workspace_uuid
    ## 1      Project 1 84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f
    ## 2      Project 2 2vo2-dd3s-1nn9-y20r-b906-u4s2-7134-b352

## Assets

Maybe you would like to download a file from one of your workspaces. In
Objective Connect, files are also known as ‘assets’. To download an
asset, you’ll need its UUID.

> Note: Where workspaces have two-factor authentication (2FA) enabled,
> participants cannot use the API for workspace level actions unless
> they have been given permission to bypass 2FA. See
> [`vignette("two-factor")`](https://scotgovanalysis.github.io/objr/dev/articles/two-factor.md)
> for more information.

Use the workspace UUID from `workspaces` to get a data frame of assets
in the workspace:

``` r
assets <- assets("84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f")
```

This returns a data frame with a row for each asset in the workspace.
Among other things, there will be a column containing the asset name and
another containing the asset UUID.

    ##   asset_name asset_ext                              asset_uuid
    ## 1      file1      docx 2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44
    ## 2      file2       csv l588-e8wp-d6y8-3d01-blby-wag1-ks1s-gmo9

## Download file

To download a document, use its UUID and the file path of the folder
you’d like the downloaded file to be saved to:

``` r
download_file(document_uuid = "2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44",
              folder = here::here("data"))
```

This function doesn’t return anything but will display a message in the
R console to indicate the download has been a success and to confirm the
location of the file:

    ## ✔ File downloaded: project-1/data/file1.docx.

## Read data

Alternatively, you can read a data file directly into your R
environment:

``` r
x <- read_data(document_uuid = "l588-e8wp-d6y8-3d01-blby-wag1-ks1s-gmo9")
```

Accepted data file formats are csv, rds and xlsx.

## Upload file

To upload a file to a workspace, use the UUID of the workspace and the
file path of the file to upload:

``` r
upload_file(here::here("data", "file3.csv"),
            workspace_uuid = "84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f")
```

This function doesn’t return anything but will display a message in the
R console to indicate the upload has been a success and to confirm the
name of the file.

    ## ✔ New document created: file3.csv.

Now, if you rerun the previous step to get a data frame of workspace
assets, you should see an additional row for the file you’ve just
uploaded.

``` r
assets <- assets("84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f")
```

    ##   asset_name asset_ext                              asset_uuid
    ## 1      file1      docx 2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44
    ## 2      file2       csv l588-e8wp-d6y8-3d01-blby-wag1-ks1s-gmo9
    ## 3      file3       csv 9tp8-3vme-d381-7o89-4qns-qw99-310b-3d06

## Write data

Alternatively, you can write data directly from R:

``` r
write_data(mtcars,
           file_name = "mtcars",
           file_type = "rds",
           workspace_uuid = "84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f")
```

``` r
assets <- assets("84op-9qdu-c692-t4z1-wa4z-h9k3-8454-i71f")
```

    ##   asset_name asset_ext                              asset_uuid
    ## 1      file1      docx 2j47-ff38-lcgg-mnis-3vq8-9536-9jfp-oy44
    ## 2      file2       csv l588-e8wp-d6y8-3d01-blby-wag1-ks1s-gmo9
    ## 3      file3       csv 9tp8-3vme-d381-7o89-4qns-qw99-310b-3d06
    ## 4     mtcars       rds fh84-jbdy-g6kp-68z8-gt3v-ds39-x74p-80m3
