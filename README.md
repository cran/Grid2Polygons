# Grid2Polygons

[![Travis-CI Build Status](https://travis-ci.org/jfisher-usgs/Grid2Polygons.svg?branch=master)](https://travis-ci.org/jfisher-usgs/Grid2Polygons)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/Grid2Polygons)](https://CRAN.R-project.org/package=Grid2Polygons)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

## Overview

The [R](https://www.r-project.org/) package **Grid2Polygons** converts a spatial object from class SpatialGridDataFrame to SpatialPolygonsDataFrame.
As an alternative, consider using the `rasterToPolygons` function in the
**[raster](https://CRAN.R-project.org/package=raster)** package setting `dissolve = TRUE`.

## Install

You can install the stable version from [CRAN](https://CRAN.R-project.org/package=Grid2Polygons) using the following command:

```r
install.packages("Grid2Polygons")
```

Or use **devtools** to install the development version from GitHub.

```r
devtools::install_github("jfisher-usgs/Grid2Polygons")
```

## Bugs

Please consider reporting bugs and asking questions on the [Issues page](https://github.com/jfisher-usgs/Grid2Polygons/issues).

## License

GPL-2 or GPL-3.
These are "copy-left" licenses.
This means that anyone who distributes the code in a bundle must license the whole bundle in a GPL-compatible way.
Additionally, anyone who distributes modified versions of the code (derivative works) must also make the source code available.
GPL-3 is a little stricter than GPL-2, closing some older loopholes.
