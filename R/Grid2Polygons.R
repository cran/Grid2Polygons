Grid2Polygons <- function (grd, zcol=1, level=FALSE, at, cuts=20,
                           pretty=FALSE) {

  # Additional functions (subroutines)

  # Find polygon nodes
  #  Input:  s          - matrix; 2-column table giving start- and end-node
  #                       indexes for each segment in a level
  #  Output: poly.nodes - list; vector components giving node indexes for each
  #                       polygon ring. Winding rule applies.
  FindPolyNodes <- function (s) {

    # Remove duplicate segments
    id <- paste(apply(s, 1, min), apply(s, 1, max), sep='')
    duplicates <- unique(id[duplicated(id)])
    s <- s[!id %in% duplicates, ]

    # Number of segments in level
    m <- nrow(s)

    # Call C program to define polygon rings
    out <- matrix(.C("define_polygons", as.integer(s[, 1]), as.integer(s[, 2]),
                     as.integer(m), "ans"=integer(m * 2))$ans, nrow=m, ncol=2)

    # Place returned array into list object
    poly.nodes <- lapply(unique(out[, 2]), function(i) out[out[, 2] == i, 1])
    poly.nodes <- lapply(poly.nodes, function(i) c(i, i[1]))

    poly.nodes
  }


  # Main program

  require(sp)

  # Check arguments
  if (!inherits(grd, "SpatialGridDataFrame"))
    stop("Grid object not of class SpatialGridDataFrame")
  if (is.character(zcol) && !(zcol %in% names(grd)))
    stop("Column name not in attribute table")
  if (is.numeric(zcol) && zcol > ncol(slot(grd, "data")))
    stop("Column number outside bounds of attribute table")

  # Determine break points
  if (level) {
    if (missing(at)) {
      zlim <- range(grd[[zcol]], finite=TRUE)
      if (pretty)
        at <- pretty(zlim, cuts)
      else
        at <- seq(zlim[1], zlim[2], length.out=cuts)
    }
    zc <- at[1:(length(at) - 1)] + diff(at) / 2
    z <- zc[findInterval(grd[[zcol]], at, rightmost.closed=TRUE)]
  } else {
    z <- grd[[zcol]]
  }

  # Define nodes and elements
  grd.par <- gridparameters(grd)
  n <- grd.par$cells.dim[1]
  m <- grd.par$cells.dim[2]
  dx <- grd.par$cellsize[1]
  dy <- grd.par$cellsize[2]
  xmin <- grd.par$cellcentre.offset[1] - dx / 2
  ymin <- grd.par$cellcentre.offset[2] - dy / 2
  xmax <- xmin + n * dx
  ymax <- ymin + m * dy
  x <- seq(xmin, xmax, by=dx)
  y <- seq(ymin, ymax, by=dy)
  nnodes <- (m + 1) * (n + 1)
  nelems <- m * n
  nodes <- 1:nnodes
  elems <- 1:nelems
  coords <- cbind(x=rep(x, m + 1), y=rep(rev(y), each=n + 1))
  n1 <- c(sapply(1:m, function(i) seq(1, n) + (i - 1) * (n + 1)))
  n2 <- n1 + 1
  n4 <- c(sapply(1:m, function(i) seq(1, n) + i * (n + 1)))
  n3 <- n4 + 1
  elem.nodes <- cbind(n1, n2, n3, n4)

  # Define segments in each element
  nsegs <- nelems * 4
  segs <- matrix(data=NA, nrow=nsegs, ncol=4,
                 dimnames=list(1:nsegs, c("elem", "a", "b", "z")))
  segs[, 1] <- rep(1:nelems, each=4)
  segs[, 2] <- c(t(elem.nodes))
  segs[, 3] <- c(t(elem.nodes[, c(2, 3, 4, 1)]))
  segs[, 4] <- rep(z, each=4)
  segs <- na.omit(segs)

  # Identify levels (or unique values)
  levs <- unique(na.omit(z))

  # Find polygon nodes for each level
  fun <- function(i) FindPolyNodes(segs[segs[, "z"] == i, c("a", "b")])
  poly.nodes <- sapply(levs, fun)

  # Build lists of Polygon objects
  fun <- function(i) lapply(i, function(j) Polygon(coords[j, ]))
  poly <- lapply(poly.nodes, fun)

  # Build list of Polygons objects
  fun <- function(i) Polygons(poly[[i]], ID=format(levs[i]))
  polys <- lapply(1:length(poly), fun)

  # Convert to SpatialPolygons object, add datum and projection
  sp.polys <- SpatialPolygons(polys, proj4string=CRS(proj4string(grd)))

  # Convert to SpatialPolygonsDataFrame object, add data frame of levels
  d <- data.frame(z=levs, row.names=row.names(sp.polys))
  sp.polys.df <- SpatialPolygonsDataFrame(sp.polys, data=d, match.ID=TRUE)

  sp.polys.df
}
