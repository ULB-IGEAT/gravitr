# Childcare accessibility with a gravity allocation model

``` r

library(gravitr)
library(dplyr)
library(sf)
library(mapsf)
library(phacochr)
library(gravitr)
```

## Why a simple ratio map is not enough

A simple ratio map compares the number of childcare places with the
number of children in each spatial unit. This is easy to read, but it
assumes that demand is only served locally. This is a strong limitation,
especially in dense urban areas where families may use childcare outside
their own sector.

``` r

data(ratio_map)

communes_bxl <- phacochr::phaco_data("communes_bxl")

mf_map(ratio_map, col = NA, border = "grey")
mf_map(communes_bxl, col = NA, border = "black", add = TRUE)

mf_map(
  ratio_map,
  var = c("supply_sector", "ratio"),
  type = "prop_choro",
  pal = "Viridis",
  nbreaks = 5,
  inches = 0.08,
  leg_title = c("Childcare places", "Places per 100 children"),
  leg_pos = c("topright", "topleft"),
  border = "black",
  lwd = 0.3,
  add = TRUE
)

mf_layout(
  title = "Local ratio of childcare places to children",
  credits = "IGEAT-ULB, 2026.",
  arrow = FALSE,
  frame = TRUE
)
```

![](childcare-accessibility_files/figure-html/unnamed-chunk-2-1.png)

## Gravity-based allocation

The gravity model allocates demand to supply locations according to
supply capacity, demand levels, and travel distance. Initial
interactions are estimated using a gravity function:

``` math
I_{ij} = \frac{S_i * D_j}{d_{ij}^{2}}
```

where $`S_i`$ is the supply, $`D_j`$ is the demand, and $`d_{ij}`$ is
the distance between demand and supply locations.

The Furness algorithm then iteratively adjusts these interactions so
that total allocated demand matches available supply while satisfying
demand constraints. The resulting allocation reflects both competition
for limited resources and travel distance, producing an accessibility
measure that accounts for service saturation and spatial separation
between users and facilities.

``` r

distance_matrix <- distance_matrix(
  supply = supply,
  demand = demand,
  min_distance = 400
)

allocation <- gravity(
  supply = supply,
  demand = demand,
  distance_matrix = distance_matrix,
  distance_power = 2,
  max_iter = 100,
  delta = 0.001,
  verbose = FALSE
)
```

## Mean distance from demand locations

The resulting allocation can be used to calculate the average travel
distance from each demand location. In the case of population-based
analyses, this indicator can be mapped for each statistical sector.

High average distances generally indicate a local shortage of supply
relative to demand. Residents in these areas must travel further to
access services because nearby facilities are insufficient or already
saturated. Mapping average distances therefore provides a simple way to
identify spatial inequalities in accessibility and areas where
additional capacity may be needed.

``` r

sec_bxl <- phacochr::phaco_data("sec_bxl")

demand_map <- sec_bxl |>
  left_join(allocation$demand, by = c("cd_sector2024" = "id"))

supply_sf <- allocation$supply |>
  st_as_sf(coords = c("x", "y"), crs = 31370)

mf_map(demand_map, col = NA, border = "grey")
mf_map(communes_bxl, col = NA, border = "black", add = TRUE)

mf_map(
  demand_map,
  var = c("demand", "mean_distance"),
  type = "prop_choro",
  pal = "Viridis",
  nbreaks = 6,
  inches = 0.09,
  leg_title = c("Children", "Mean distance"),
  leg_pos = c("topright", "topleft"),
  border = "black",
  lwd = 0.3,
  add = TRUE
)

mf_map(
  supply_sf,
  type = "prop",
  var = "supply",
  inches = 0.04,
  col = "red",
  leg_title = "Childcare capacity",
  leg_pos = "left",
  border = NA,
  add = TRUE
)

mf_layout(
  title = "Mean distance from demand locations",
  credits = "IGEAT-ULB, 2026.",
  arrow = FALSE,
  frame = TRUE
)
```

![](childcare-accessibility_files/figure-html/unnamed-chunk-4-1.png)
