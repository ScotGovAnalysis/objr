
# objr

<!-- badges: start -->

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/scotgovanalysis/objr)](https://github.com/scotgovanalysis/objr/releases/latest)
[![R build status](https://github.com/scotgovanalysis/objr/workflows/R-CMD-check/badge.svg)](https://github.com/scotgovanalysis/objr/actions)

<!-- badges: end -->

objr aims to provide a convenient method of interacting with [Objective Connect](https://secure.objectiveconnect.co.uk) using R, making use of the [Objective Connect API](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html).

## Installation

If you are working within the Scottish Government network, you can
install objr in the same way as with other R packages. The easiest way to do this is by using the [pkginstaller](https://github.com/ScotGovAnalysis/pkginstaller/tree/main) add-in. Further guidance is available on [eRDM](https://erdm.scotland.gov.uk:8443/documents/A42404229/details).

Alternatively, objr can be installed directly from GitHub. Note that this method requires the remotes package and may not work from within the Scottish Government network.

``` r
remotes::install_github(
  "ScotGovAnalysis/objr",
  upgrade = "never",
  build_vignettes = TRUE
)
```

Finally, objr can also be installed by downloading the [zip of the
repository](https://github.com/ScotGovAnalysis/objr/archive/main.zip)
and running the following code, replacing the section marked `<>`
(including the arrows themselves) with the location of the downloaded
zip:

``` r
remotes::install_local(
  "<FILEPATH OF ZIPPED FILE>/objr-main.zip",
  upgrade = "never",
  build_vignettes = TRUE
)
```


## Licence

Unless stated otherwise, the codebase is released under [the MIT
Licence](LICENCE).
This covers both the codebase and any sample code in
the documentation.

The documentation is [© Crown copyright](https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government 3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
