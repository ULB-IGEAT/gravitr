# Compute a distance matrix

Compute a distance matrix

## Usage

``` r
distance_matrix(
  supply,
  demand,
  supply_x = "x",
  supply_y = "y",
  demand_x = "x",
  demand_y = "y",
  min_distance = 400
)
```

## Arguments

- supply:

  A data frame containing supply locations.

- demand:

  A data frame containing demand locations.

- supply_x:

  Name of the x-coordinate column in `supply`.

- supply_y:

  Name of the y-coordinate column in `supply`.

- demand_x:

  Name of the x-coordinate column in `demand`.

- demand_y:

  Name of the y-coordinate column in `demand`.

- min_distance:

  Minimum distance value. Distances below this value are replaced.

## Value

A numeric matrix with supply units in rows and demand units in columns.
