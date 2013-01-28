\name{DEM}

\alias{DEM}

\docType{data}

\title{Example Digital Elevation Model}

\description{
The west, east, north, and south bounding coordinates are about
-115.4, -111.4, 44.5, and 42.2 decimal degrees, respectively.
Grid resolution is 500 by 500 meter.
}

\usage{
DEM
}

\format{
An object of \code{\link{SpatialGridDataFrame-class}} with 323,724
points (coordinates) and a single data attribute (elevation).
Geographic coordinates are in units of meters, in conformance
with the North American Datum of 1927, and placed in a
Albers Equal-Area Conic projection; standard parallels 42.83, 44.16;
central meridian -113.00, false easting 200,000 meters; false northing 0.
}


\source{
The National Elevation Dataset (\href{http://ned.usgs.gov/}{NED})
1-arc-second raster. Dataset resampled to 10 arc-seconds using a
cubic convolution assignment.
}

\examples{
data(DEM)
summary(DEM)
}

\keyword{datasets}
