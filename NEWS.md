# objr (development version)

* `download_file()` now writes files with percent-decoded names 
(e.g. `file%20name.csv` is now `file name.csv`) (#34).

* Fixed an issue where temporary files sometimes persisted after running 
`download_file()` or `read_file()` (#39).

# objr 0.1.1

* Set minimum versions for `dplyr` and `tidyr` dependencies (#32).

# objr 0.1.0

* First package release.

* Add pkgdown site (https://ScotGovAnalysis.github.io/objr).
