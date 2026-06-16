library(foreign)
library(dplyr)
library(sf)
library(phacochr)

sec_bxl <- phaco_data("sec_bxl")

pop <- read.dbf("data-raw/creche/POP_HY.DBF", as.is = TRUE) |>
  group_by(SS) |>
  summarise(pop = sum(POP, na.rm = TRUE), .groups = "drop")

demand <- sec_bxl |>
  left_join(pop, by = c("cd_sector2024" = "SS")) |>
  filter(pop > 0, !is.na(pop)) |>
  st_point_on_surface() |>
  mutate(
    x = st_coordinates(GEOMETRY)[, 1],
    y = st_coordinates(GEOMETRY)[, 2]
  ) |>
  st_drop_geometry() |>
  select(id = cd_sector2024, x, y, demand = pop)

creche <- read.dbf("data-raw/creche/CRECH_HY.DBF", as.is = TRUE)

supply <- creche |>
  mutate(
    x = X,
    y = Y,
    supply = sum(demand$demand) * PLACES / sum(PLACES, na.rm = TRUE)
  ) |>
  select(id = ID_CRECHE, x, y, supply)

creche_sector <- creche |>
  group_by(SS) |>
  summarise(supply_sector = sum(PLACES, na.rm = TRUE), .groups = "drop")

ratio_map <- sec_bxl |>
  left_join(demand, by = c("cd_sector2024" = "id")) |>
  left_join(creche_sector, by = c("cd_sector2024" = "SS")) |>
  mutate(
    supply_sector = ifelse(is.na(supply_sector), 0, supply_sector),
    ratio = 100 * supply_sector / demand
  )

usethis::use_data(demand, supply, ratio_map, overwrite = TRUE)

