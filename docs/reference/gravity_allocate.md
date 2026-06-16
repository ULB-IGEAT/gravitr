# Allocate supply and demand using a gravity model with Furness convergence

Allocate supply and demand using a gravity model with Furness
convergence

## Usage

``` r
gravity_allocate(
  supply,
  demand,
  distance_matrix,
  supply_col = "supply",
  demand_col = "demand",
  distance_power = 2,
  max_iter = 100,
  delta = 0.001,
  min_improvement = 1e-04,
  verbose = TRUE
)
```

## Arguments

- supply:

  A data frame containing supply values.

- demand:

  A data frame containing demand values.

- distance_matrix:

  A matrix of distances. Rows must match supply, columns must match
  demand.

- supply_col:

  Name of the supply column.

- demand_col:

  Name of the demand column.

- distance_power:

  Power applied to distance in the initial gravity formula.

- max_iter:

  Maximum number of iterations.

- delta:

  Convergence threshold.

- min_improvement:

  Minimum relative improvement before stopping.

- verbose:

  If `TRUE`, prints convergence messages.

## Value

A list containing flows, weighted distances, summaries and convergence
information.
