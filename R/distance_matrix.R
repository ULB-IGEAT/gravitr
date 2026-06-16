#' Compute a distance matrix
#'
#' @param supply A data frame containing supply locations.
#' @param demand A data frame containing demand locations.
#' @param supply_x Name of the x-coordinate column in `supply`.
#' @param supply_y Name of the y-coordinate column in `supply`.
#' @param demand_x Name of the x-coordinate column in `demand`.
#' @param demand_y Name of the y-coordinate column in `demand`.
#' @param min_distance Minimum distance value. Distances below this value are replaced.
#'
#' @return A numeric matrix with supply units in rows and demand units in columns.
#' @export
compute_distance_matrix <- function(
    supply,
    demand,
    supply_x = "x",
    supply_y = "y",
    demand_x = "x",
    demand_y = "y",
    min_distance = 400
) {
  dx <- outer(supply[[supply_x]], demand[[demand_x]], "-")
  dy <- outer(supply[[supply_y]], demand[[demand_y]], "-")

  distances <- sqrt(dx^2 + dy^2)
  distances[distances < min_distance] <- min_distance

  distances
}
