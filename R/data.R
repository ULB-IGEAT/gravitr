#' Childcare demand locations
#'
#' A data frame containing demand locations and the number of children.
#'
#' @keywords internal
#'
#' @format A data frame with 4 columns:
#' \describe{
#'   \item{id}{Sector identifier.}
#'   \item{x}{X coordinate.}
#'   \item{y}{Y coordinate.}
#'   \item{demand}{Demand value.}
#' }
"demand"

#' Childcare supply locations
#'
#' A data frame containing childcare locations and capacity.
#'
#' @keywords internal
#'
#' @format A data frame with 4 columns:
#' \describe{
#'   \item{id}{Childcare facility identifier.}
#'   \item{x}{X coordinate.}
#'   \item{y}{Y coordinate.}
#'   \item{supply}{Supply value.}
#' }
"supply"

#' Sector-level childcare ratio map
#'
#' An sf object containing childcare supply, demand and local ratio by sector.
#'
#' @keywords internal
#'
#' @format An sf object with sector geometries and ratio variables.
"ratio_map"
