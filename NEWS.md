# objr (development version)

* Added `CONTRIBUTING.md` and `SUPPORT.md` (#36).

* `download_file()` now returns file path (invisibly) (#38).

* `download_file()` now accepts custom file name in `file_name` argument (#37).

* `download_file()` now writes files with percent-decoded names 
(e.g. `file%20name.csv` is now `file name.csv`) (#34).

* Fixed an issue where temporary files sometimes persisted after running 
`download_file()` or `read_data()` (#39).

* Added support for parquet files in `read/write_data` and 
`read/write_data_version()`(#54).

# objr 0.1.1

* Set minimum versions for `dplyr` and `tidyr` dependencies (#32).

# objr 0.1.0

* First package release.

* Add pkgdown site (https://ScotGovAnalysis.github.io/objr).
