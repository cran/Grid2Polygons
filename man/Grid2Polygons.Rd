% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Grid2Polygons.R
\name{Grid2Polygons}
\alias{Grid2Polygons}
\title{Convert Spatial Grids to Polygons}
\usage{
Grid2Polygons(grd, zcol = 1, level = FALSE, at, cuts = 20,
  pretty = FALSE, xlim = NULL, ylim = NULL, ply = NULL, ...)
}
\arguments{
\item{grd}{SpatialGridDataFrame.
Spatial grid data frame}

\item{zcol}{character or integer.
Attribute name or column number in attribute table.}

\item{level}{logical.
If true, a set of levels is used to partition the range of \code{z}, its default is false.}

\item{at}{numeric.
A vector giving breakpoints along the range of \code{z}.}

\item{cuts}{integer.
Number of levels the range of \code{z} would be divided into.}

\item{pretty}{logical.
Whether to use pretty cut locations.}

\item{xlim}{numeric.
Vector of length 2 giving left and right limits of the spatial grid, data outside these limits is excluded.}

\item{ylim}{numeric.
Vector of length 2 giving lower and upper limits of the spatial grid, data outside these limits is excluded.}

\item{ply}{SpatialPolygons, or SpatialGridDataFrame.
Cropping polygon}

\item{...}{Not used}
}
\value{
Returns an object of SpatialPolygonsDataFrame.
  The objects \code{data} slot is a data frame, number of rows equal to
  the number of \code{Polygons} objects and a single column containing values of \code{z}.
  If \code{level} is true, \code{z} values are set equal to the midpoint between breakpoints.
  The status of the polygon as a hole or an island is taken from the ring direction,
  with clockwise meaning island, and counter-clockwise meaning hole.
}
\description{
This function has been deprecated; please use \code{inlmisc::Grid2Polygons} instead.
Used to convert \pkg{sp} spatial objects from class '\code{\link{SpatialGridDataFrame}}' to '\code{\link{SpatialPolygonsDataFrame}}'.
Spatial polygons can then be transformed to a different projection or datum with \code{spTransform} in package \pkg{rgdal}.
Image files created with spatial polygons are reduced in size and result in a much "cleaner" version of your image.
}
\details{
Converts \pkg{sp} spatial objects from class \code{\link{SpatialGridDataFrame}} to \code{\link{SpatialPolygonsDataFrame}}.
Spatial polygons can then be transformed to a different projection or datum with \code{spTransform} in package \pkg{rgdal}.
Image files created with spatial polygons are reduced in size and result in a much "cleaner" version of your image.
}
\note{
The traditional R graphics model does not draw polygon holes correctly,
  holes overpaint their containing \code{Polygon} object using a user defined background color (white by default).
  Polygon holes are now rendered correctly using the \code{plot} method for spatial polygons (\code{\link{SpatialPolygons-class}}),
  see \code{\link{polypath}} for more details.
  The Trellis graphics model appears to rely on the traditional method so
  use caution when plotting with \code{\link[sp]{spplot}}.
}
\examples{
\dontrun{
data(meuse.grid, package = "sp")
sp::coordinates(meuse.grid) <- ~ x + y
sp::gridded(meuse.grid) <- TRUE
meuse.grid <- as(meuse.grid, "SpatialGridDataFrame")
meuse.plys <- Grid2Polygons(meuse.grid, "dist", level = FALSE)
op <- par(mfrow = c(1, 2), oma = rep(0, 4), mar = rep(0, 4))
sp::plot(meuse.plys, col = heat.colors(length(meuse.plys)))
title("level = FALSE", line = -7)
meuse.plys.lev <- Grid2Polygons(meuse.grid, "dist", level = TRUE)
sp::plot(meuse.plys.lev, col = heat.colors(length(meuse.plys.lev)))
title("level = TRUE", line = -7)
par(op)
}

}
\references{
A general explanation of the algorithm provided
  \href{https://stackoverflow.com/questions/643995/algorithm-to-merge-adjacent-rectangles-into-polygon}{here};
  inspiration provided \href{https://menugget.blogspot.com/2012/04/create-polygons-from-matrix.html}{here}.
}
\seealso{
\code{\link[inlmisc]{Grid2Polygons}}
}
\author{
J.C. Fisher, U.S. Geological Survey, Idaho Water Science Center
}
\keyword{manip}
