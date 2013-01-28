\name{Grid2Polygons}

\alias{Grid2Polygons}

\title{Convert Spatial Grids to Polygons}

\description{
Converts \pkg{sp} spatial objects from class \code{\link{SpatialGridDataFrame}}
to \code{\link{SpatialPolygonsDataFrame}}. Spatial polygons can then be
transformed to a different projection or datum with \code{spTransform}
in package \pkg{rgdal}. Image files created with spatial polygons are
reduced in size and result in a much "cleaner" version of your image.
}

\usage{
Grid2Polygons(grd, zcol = 1, level = FALSE, at, cuts = 20, pretty = FALSE,
              xlim = NULL, ylim = NULL, ply = NULL)
}

\arguments{
\item{grd}{SpatialGridDataFrame; spatial grid data frame.}
\item{zcol}{character or integer; attribute name or column
  number in attribute table.}
\item{level}{logical; if \code{TRUE} a set of levels is used to
   partition the range of \code{z}, its default is \code{FALSE}.}
\item{at}{numeric; a vector giving breakpoints along the range of
  \code{z}.}
\item{cuts}{integer; number of levels the range of \code{z} would be
  divided into.}
\item{pretty}{logical; whether to use pretty cut locations.}
\item{xlim}{numeric; vector of length 2 giving left and right limits of the 
  spatial grid, data outside these limits is excluded.}
\item{ylim}{numeric; vector of length 2 giving lower and upper limits of 
  the spatial grid, data outside these limits is excluded.}
\item{ply}{gpc.poly, SpatialPolygons, or SpatialGridDataFrame; 
  cropping polygon.}
}

\value{
Returns an object of class \code{SpatialPolygonsDataFrame}. The objects
\code{data} slot is a data frame, number of rows equal to the number of
\code{Polygons} objects and a single column containing values of \code{z}.
If \code{level} is \code{TRUE}, \code{z} values are set equal to the midpoint
between breakpoints. The status of the polygon as a hole or an island is
taken from the ring direction, with clockwise meaning island, and
counter-clockwise meaning hole.
}

\note{
The traditional R graphics model does not draw polygon holes correctly,
holes overpaint their containing \code{Polygon} object using a user defined
background color (white by default). Polygon holes are now
rendered correctly using the \code{plot} method for spatial polygons
(\code{\link{SpatialPolygons-class}}), see \code{\link{polypath}} for more
details. The Trellis graphics model appears to rely on the traditional method so
use caution when plotting with \code{\link{spplot}}.
}

\author{J.C. Fisher}

\references{
A general explanation of the algorithm provided
\href{http://stackoverflow.com/questions/643995/algorithm-to-merge-adjacent-rectangles-into-polygon}{here};
inspiration provided
\href{http://menugget.blogspot.com/2012/04/create-polygons-from-matrix.html}{here}.
}

\seealso{
\code{\link{Polygon}}, \code{\link{Polygons}}, \code{\link{SpatialPolygons}},
\code{\link[sp]{CRS}}
}

\examples{
# Example 1

m <- 5
n <- 6
z <- c(1.1,  1.5,  4.2,  4.1,  4.3,  4.7,
       1.2,  1.4,  4.8,  4.8,   NA,  4.1,
       1.7,  4.2,  1.4,  4.8,  4.0,  4.4,
       1.1,  1.3,  1.2,  4.8,  1.6,   NA,
       3.3,  2.9,   NA,  4.1,  1.0,  4.0)
x <- rep(0:6, m + 1)
y <- rep(0:5, each = n + 1)
xc <- c(rep(seq(0.5, 5.5, by = 1), m))
yc <- rep(rev(seq(0.5, 4.5, by = 1)), each = n)
grd <- data.frame(z = z, xc = xc, yc = yc)
coordinates(grd) <- ~ xc + yc
gridded(grd) <- TRUE
grd <- as(grd, "SpatialGridDataFrame")
image(grd, col = gray.colors(30), axes = TRUE)
grid(col = "black", lty = 1)
points(x = x, y = y, pch = 16)
text(cbind(xc, yc), labels = z)
text(cbind(x = x + 0.1, y = rev(y + 0.1)), labels = 1:42, cex = 0.6)

plys <- Grid2Polygons(grd, level = TRUE, at = 1:5)
cols <- rainbow(length(plys), alpha = 0.3)
plot(plys, add = TRUE, col = cols)
legend("top", legend = plys[[1]], fill = cols, bty = "n", xpd = TRUE, 
       inset = c(0, -0.1), ncol = length(plys))

v <- matrix(c(2.5, 3.4, 3.7, 2.5, 2.5, 1.8, 3.1, 2.5), nrow = 4, ncol = 2)
ply.0 <- Polygon(v, hole = TRUE)
v <- matrix(c(1.2, 5.8, 2.5, 1.2, 0.5, 1.7, 5.1, 0.5), nrow = 4, ncol = 2)
ply.1 <- Polygon(v, hole = FALSE)
v <- matrix(c(-0.3, 1.7, -1.0, -0.3, 3.3, 5.1, 7.0, 3.3), nrow = 4, ncol = 2)
ply.2 <- Polygon(v, hole = FALSE)
ply <- SpatialPolygons(list(Polygons(list(ply.0, ply.1, ply.2), 1)))
plys <- Grid2Polygons(grd, level = TRUE, at = 1:5, ply = ply)
cols <- colorRampPalette(c("red", "gold", "green"))(length(plys))
plot(plys, add = TRUE, col = cols)
legend(xy.coords(1.9, -0.9), legend = plys[[1]], fill = cols, bty = "n", 
       xpd = TRUE, inset = c(0, -0.1), ncol = length(plys))

# Example 2

data(meuse.grid)
coordinates(meuse.grid) <- ~ x + y
gridded(meuse.grid) <- TRUE
meuse.grid <- as(meuse.grid, "SpatialGridDataFrame")
meuse.plys <- Grid2Polygons(meuse.grid, "dist", level = FALSE)
op <- par(mfrow = c(1, 2), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0))
plot(meuse.plys, col = heat.colors(length(meuse.plys)))
title("level = FALSE", line = -7)

meuse.plys.lev <- Grid2Polygons(meuse.grid, "dist", level = TRUE)
plot(meuse.plys.lev, col = heat.colors(length(meuse.plys.lev)))
title("level = TRUE", line = -7)
par(op)

\dontrun{
# Example 3

data(DEM)
at <- seq(500, 4000, by = 250)
op <- par(oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0))
image(DEM, breaks = at, col = terrain.colors(length(at) - 1L))

dem.plys <- Grid2Polygons(DEM, level = TRUE, at = at)
cols <- terrain.colors(length(dem.plys))
plot(dem.plys, border = "transparent", col = cols)

library(rgdal)
dem.plys.trans <- rgdal::spTransform(dem.plys, CRS = CRS("+proj=eqc"))
plot(dem.plys.trans, border = "transparent", col = cols)

dem.plys.lims <- Grid2Polygons(DEM, level = TRUE,  pretty = TRUE,
                               xlim = c(178000, 257500), 
                               ylim = c(202000, 272000))
plot(dem.plys.lims, border = "transparent", 
     col = terrain.colors(length(dem.plys.lims)))

v <- matrix(c(89500, 169000, 248500, 89500, 272075, 144825, 272075, 272075), 
            nrow = 4, ncol = 2)
ply <- SpatialPolygons(list(Polygons(list(Polygon(v, hole = FALSE)), 1)))
dem.plys.crop <- Grid2Polygons(DEM, level = TRUE,  pretty = TRUE, ply = ply)
plot(dem.plys.crop, border = "transparent", 
     col = terrain.colors(length(dem.plys.crop)))
par(op)}
}

\keyword{manip}
