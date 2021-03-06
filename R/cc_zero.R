#' Flag Zero Coordinates
#' 
#' Flags records with either zero longitude or latitude and a radius around the
#' point at zero longitude and zero latitude. These problems are often due to
#' erroneous data-entry or geo-referencing and can lead to typical patterns of
#' high diversity around the equator.
#' 
#' 
#' @param x a data.frame. Containing geographical coordinates and species
#' names.
#' @param lon a character string. The column with the longitude coordinates.
#' Default = \dQuote{decimallongitude}.
#' @param lat a character string. The column with the longitude coordinates.
#' Default = \dQuote{decimallatitude}.
#' @param buffer numerical. The buffer around each province or country
#' centroid, where records should be flagged as problematic, in decimal
#' degrees.  Default = 0.1.
#' @param value a character string.  Defining the output value. See value.
#' @param verbose logical. If TRUE reports the name of the test and the number
#' of records flagged.
#' @return Depending on the \sQuote{value} argument, either a \code{data.frame}
#' containing the records considered correct by the test (\dQuote{clean}) or a
#' logical vector (\dQuote{flagged}), with TRUE = test passed and FALSE = test failed/potentially
#' problematic. Default = \dQuote{clean}.
#' @note See \url{https://azizka.github.io/CoordinateCleaner/} for more
#' details and tutorials.
#' @keywords Coordinate cleaning
#' @family Coordinates
#' @examples
#' 
#' x <- data.frame(species = "A", 
#'                 decimallongitude = c(0,34.84, 0, 33.98), 
#'                 decimallatitude = c(23.08, 0, 0, 15.98))
#'                 
#' cc_zero(x)
#' cc_zero(x, value = "flagged")
#' 
#' @export
#' @importFrom sp SpatialPoints over
#' @importFrom rgeos gBuffer
cc_zero <- function(x, 
                    lon = "decimallongitude", 
                    lat = "decimallatitude",
                    buffer = 0.5,
                    value = "clean", 
                    verbose = TRUE) {

  # check value argument
  match.arg(value, choices = c("clean", "flagged"))

  if (verbose) {
    message("Testing zero coordinates")
  }

  # plain zero in coordinates
  t1 <- !(x[[lon]] == 0 | x[[lat]] == 0)

  # radius around point 0/0
  dat <- sp::SpatialPoints(x[, c(lon, lat)])
  t2 <- rgeos::gBuffer(sp::SpatialPoints(cbind(0, 0)), width = buffer)
  t2 <- is.na(sp::over(x = dat, y = t2))

  # combine test results
  out <- Reduce("&", list(t1, t2))

  if (verbose) {
    message(sprintf("Flagged %s records.", sum(!out)))
  }

  switch(value, clean = return(x[out, ]), flagged = return(out))
}
