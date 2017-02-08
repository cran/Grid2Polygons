# Grid2Polygons 0.1.6

- Replace custom code used for cropping the SpatialPolygonsDataFrame with `raster::crop` function.

- Update URL links to HTTP Secure

- Generalize CITATION file

# Grid2Polygons 0.1.5

- Import **sp** and **rgeos** package functions in the NAMESPACE file.

# Grid2Polygons 0.1.4

- Removed DEM data set and Example 3 from documentation.

- Replaced deprecated `sp::overlay` function with `sp::over`.

# Grid2Polygons 0.1.2

- Added option to crop spatial domain using polygons.

# Grid2Polygons 0.1.1

- Sorted z levels to make color specification much easier when plotting.

- Added option to limit raster extent in the four coordinate directions.

- Fixed error with list construction; error sometimes occurs when specifying breakpoints.

- Updated examples in documentation
