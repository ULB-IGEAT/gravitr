#' Allocate supply and demand using a gravity model with Furness convergence
#'
#' @param supply A data frame containing supply values.
#' @param demand A data frame containing demand values.
#' @param distance_matrix A matrix of distances. Rows must match supply, columns must match demand.
#' @param supply_col Name of the supply column.
#' @param demand_col Name of the demand column.
#' @param distance_power Power applied to distance in the initial gravity formula.
#' @param max_iter Maximum number of iterations.
#' @param delta Convergence threshold.
#' @param min_improvement Minimum relative improvement before stopping.
#' @param verbose If `TRUE`, prints convergence messages.
#'
#' @return A list containing flows, weighted distances, summaries and convergence information.
#' @export
gravity <- function(
    supply,
    demand,
    distance_matrix,
    supply_col = "supply",
    demand_col = "demand",
    distance_power = 2,
    max_iter = 100,
    delta = 0.001,
    min_improvement = 0.0001,
    verbose = TRUE
) {
  supply_values <- supply[[supply_col]]
  demand_values <- demand[[demand_col]]

  if (nrow(distance_matrix) != length(supply_values)) {
    stop("The number of rows in `distance_matrix` must match the number of supply units.")
  }

  if (ncol(distance_matrix) != length(demand_values)) {
    stop("The number of columns in `distance_matrix` must match the number of demand units.")
  }

  flows <- outer(supply_values, demand_values, "*") / distance_matrix^distance_power

  n <- 0
  delta_row <- Inf
  delta_row_before <- Inf

  while (delta_row > delta && n < max_iter) {
    n <- n + 1

    flows <- flows * supply_values / rowSums(flows)
    flows <- t(t(flows) * demand_values / colSums(flows))

    delta_row <- sum(abs(rowSums(flows) - supply_values))

    if (verbose) {
      message(
        "Iteration ", n,
        " | delta_row = ", round(delta_row, 6)
      )
    }

    if (
      n > 1 &&
      is.finite(delta_row_before) &&
      ((delta_row_before - delta_row) / delta_row_before) < min_improvement
    ) {
      if (verbose) {
        message("Stopped: improvement below threshold.")
      }
      break
    }

    delta_row_before <- delta_row
  }

  weighted_distances <- flows * distance_matrix

  demand_results <- demand |>
    dplyr::mutate(
      mean_distance = colSums(weighted_distances, na.rm = TRUE) / demand_values
    )

  supply_results <- supply |>
    dplyr::mutate(
      mean_distance = rowSums(weighted_distances, na.rm = TRUE) / supply_values
    )

  list(
    flows = flows,
    weighted_distances = weighted_distances,
    demand = demand_results,
    supply = supply_results,
    iterations = n,
    delta_row = delta_row,
    converged = delta_row <= delta
  )
}
