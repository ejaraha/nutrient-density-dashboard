#source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

energy <- nrf_calculation %>% 
  filter(nutrient_name == "Energy" & nutrient_unit == "kcal") %>%
  rename("energy_per_100g" = nutrient_per_100g,
         "energy_unit" = nutrient_unit) %>%
  select(!c(id, nutrient_name)) 

daily_value_sub <- daily_value %>%
  subset(select = -nutrient_name) # to eliminate clash with nrf_calculation.nutrient_name when joining

nrf_calculation <- nrf_calculation  %>% 
  mutate(nutrient_name = case_when(nutrient_name == "Calcium, Ca" ~"calcium",
                                   nutrient_name == "Fatty acids, total saturated" ~"saturated fat",
                                   nutrient_name == "Fiber, total dietary" ~"dietary fiber",
                                   nutrient_name == "Iron, Fe" ~"iron",
                                   nutrient_name == "Potassium, K" ~"potassium",
                                   nutrient_name == "Protein" ~"protein",
                                   nutrient_name == "Sodium, Na" ~"sodium",
                                   nutrient_name == "Sugars, Total NLEA" ~"total sugars",
                                   nutrient_name == "Vitamin D (D2 + D3), International Units" ~"vitamin d",
                                   TRUE ~nutrient_name),
         nutrient_id = case_when(nutrient_name == "protein" ~1,
                                 nutrient_name == "dietary fiber" ~2,
                                 nutrient_name == "vitamin d" ~3,
                                 nutrient_name == "potassium" ~4,
                                 nutrient_name == "calcium" ~5,
                                 nutrient_name == "iron" ~6,
                                 nutrient_name == "sodium" ~7,
                                 nutrient_name == "total sugars" ~8,
                                 nutrient_name == "saturated fat" ~9,
                                  TRUE ~9999),
         nutrient_per_100g = case_when(nutrient_unit == "iu" ~nutrient_per_100g*0.025,
                                       TRUE ~as.double(nutrient_per_100g)),
         nutrient_unit = case_when(nutrient_unit == "iu" ~"mcg",
                                   TRUE ~nutrient_unit)) %>%
  filter(nutrient_name != "Energy") %>% # join energy for nutrient/100kcal calculation
  left_join(energy, by="fdc_id") %>%
  left_join(daily_value_sub, by=c("nutrient_id"="dv_id"))

nrf <- nrf_calculation %>%
  mutate(nutrient_per_100g = case_when(nutrient_type == "limit" ~ -nutrient_per_100g,
                                       TRUE ~nutrient_per_100g)) %>% 
  mutate("nrf" = (nutrient_per_100g/daily_value)*100,
         nrf = case_when(nrf > 100 ~100,
                         nrf < -100 ~ -100,
                         TRUE ~round(nrf))) %>%
  group_by(fdc_id) %>%
  summarize("nrf" = sum(nrf))

food_nrf <- nrf_food_descriptions %>%
  left_join(nrf, by="fdc_id") 

food_nrf %>% filter(grepl("rice, white", description)
                    & data_type == "survey_fndds_food"
                    & between(nrf, 0,5) == TRUE) 
