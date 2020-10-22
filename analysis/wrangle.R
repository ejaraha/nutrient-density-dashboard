source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

energy <- nrf_calculation %>% 
  filter(nutrient_name == "Energy" & nutrient_unit == "KCAL") %>%
  rename("energy_per_100g" = amount_per_100g,
         "energy_unit" = nutrient_unit) %>%
  select(!c(id, nutrient_name)) 

nrf_calculation  %>% 
  mutate(nutrient_name = case_when(nutrient_name == "Calcium, Ca" ~"calcium",
                                   nutrient_name == "Fatty acids, total saturated" ~"saturated fat",
                                   nutrient_name == "Fiber, total dietary" ~"dietary fiber",
                                   nutrient_name == "Iron, Fe" ~"iron",
                                   nutrient_name == "Potassium, K" ~"potassium",
                                   nutrient_name == "Protein" ~"protein",
                                   nutrient_name == "Sodium, Na" ~"sodium",
                                   nutrient_name == "Sugars, added" ~"added sugars",
                                   nutrient_name == "Vitamin D (D2 + D3)" ~"vitamin d",
                                   nutrient_name == "Vitamin D (D2 + D3), International Units" ~"vitamin d IU")) %>% 
  left_join(energy, by="fdc_id") %>%
  glimpse()


#food_equivalent %>% glimpse()