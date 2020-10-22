source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

nrf_calculation %>%
  distinct(nutrient_name) %>%
  arrange(nutrient_name)


#food_equivalent %>% glimpse()