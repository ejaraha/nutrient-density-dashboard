source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

###############################################################################
# VARIABLES

#energy contents per 100g
energy <- food_nutrient %>% 
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  left_join(all_of(fndds_survey), by="fdc_id") %>%
  filter(name == "Energy" & unit_name == "KCAL"
         & is.na(food_code) != TRUE) %>%
  rename("energy_per_100g" = amount,
         "energy_unit" = unit_name) %>%
  mutate(energy_unit = tolower(energy_unit)) %>%
  select(fdc_id,
         food_code,
         energy_per_100g,
         energy_unit) 

# variables necessary to calculate nutrient density scores (hybrid and 6.3)
variables_food_group_score <- food_group_equivalent %>% # food group equivalents in 100g of each food
  #dga recommended daily intake (only for food groups used in the hybrid nutrient density score)
  left_join(daily_value_food_group, by="nrf_fg_id") %>%
  #energy in 100g of food
  left_join(energy, by="food_code")

# variables necessary to calculate the nutrient-to-limit and nutrients-to-encourage components of the nutrient density score (hybrid and 6.3)
variables_nutrient_score <- food %>% # food names and data types
  # fndds foods only
  filter(data_type == "survey_fndds_food") %>%
  # nutrient amounts
  left_join(all_of(food_nutrient), by="fdc_id") %>% 
  # nutrient names and units
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  # energy content in 100g food (kcal)
  left_join(all_of(energy), by="fdc_id") %>%
  # clean names
  rename(nutrient_name = name,
         nutrient_per_100g = amount,
         nutrient_unit = unit_name) %>% 
  mutate(nutrient_unit = tolower(nutrient_unit),
         description = tolower(description),
         nutrient_name = case_when(nutrient_name == "Calcium, Ca" ~"calcium",
                                   nutrient_name == "Fatty acids, total saturated" ~"saturated fat",
                                   nutrient_name == "Fiber, total dietary" ~"dietary fiber",
                                   nutrient_name == "Iron, Fe" ~"iron",
                                   nutrient_name == "Potassium, K" ~"potassium",
                                   nutrient_name == "Protein" ~"protein",
                                   nutrient_name == "Sodium, Na" ~"sodium",
                                   nutrient_name == "Sugars, Total NLEA" ~"total sugars",
                                   nutrient_name == "Vitamin D (D2 + D3), International Units" ~"vitamin d",
                                   TRUE ~nutrient_name),
         # assign id for nrf nutrients to aid in joining daily values
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
         # convert IU to g for vitamin D
         nutrient_per_100g = case_when(nutrient_unit == "iu" ~nutrient_per_100g*0.025,
                                       TRUE ~as.double(nutrient_per_100g)),
         nutrient_unit = case_when(nutrient_unit == "iu" ~"mcg",
                                   TRUE ~nutrient_unit)) %>% 
  # daily values for each nutrient
  left_join(daily_value_nutrient[-2], by=c("nutrient_id"="dv_id")) %>% # daily_value_nutrient[-2] to eliminate clash with nrf_variables.nutrient_name when joining
  # filter only necessary nutrients
  filter(nutrient_id %in% c(1:9)) %>%
  select(id,
         fdc_id,
         description,
         nutrient_name,
         nutrient_per_100g,
         nutrient_unit,
         daily_value,
         daily_value_unit,
         nutrient_type,
         energy_per_100g,
         energy_unit)

###############################################################################
# PCT DAILY VALUES (nutrients and food groups)

# calculate the % daily value that each food fulfills for each nutrient 
pct_dv_nutrients <- variables_nutrient_score %>%
  mutate(nutrient_per_100g = case_when(nutrient_type == "limit" ~ -nutrient_per_100g,
                                       TRUE ~nutrient_per_100g),
         #calculate nutrient score: [1] calculate %DV per kcal then multiply by 100 to get %DV per 100 kcal
         "pct_dv_per_100kcal" = round((nutrient_per_100g/energy_per_100g/daily_value)*100*100),
         #cap daily values at 100%
         pct_dv_per_100kcal = case_when(pct_dv_per_100kcal > 100 ~100,
                                        pct_dv_per_100kcal < -100 ~ -100,
                                        TRUE ~pct_dv_per_100kcal)) %>%
  rename("component" = nutrient_name) %>%
  select(fdc_id,
         description,
         component,
         pct_dv_per_100kcal)

# calculate the % daily recommendation that each food fulfills for each food group in the nutrient density food group component
pct_dv_food_groups <- variables_food_group_score %>%
  #only consider food groups that contribute to the nrf fg score
  filter(is.na(food_group_nrf) != TRUE) %>%
  #calculate food group score: [1] calculate %DV per kcal then multiply by 100 to get %DV per 100 kcal
  mutate("pct_dv_per_100kcal" = round((equivalents_per_100g/energy_per_100g/daily_rec_dga)*100*100),
         #cap daily values at 100%
         pct_dv_per_100kcal = case_when(pct_dv_per_100kcal > 100 ~100,
                                        pct_dv_per_100kcal < -100 ~ -100,
                                        TRUE ~pct_dv_per_100kcal)) %>%
  rename("component" = food_group) %>%
  select(fdc_id,
         description,
         component,
         pct_dv_per_100kcal)

# bind nutrient & food group %dvs
pct_dv <- bind_rows(pct_dv_food_groups, pct_dv_nutrients) %>%
  mutate(pct_dv_per_100kcal = abs(pct_dv_per_100kcal)) %>%
  arrange(fdc_id)

###############################################################################
# FOOD SCORES

# nrf6.3
nrf_63 <- pct_dv_nutrients %>%
  group_by(fdc_id) %>%
  summarize("nrf_63" = round(sum(pct_dv_per_100kcal))) 

# nrf_fg (food group variable of hybrid nrf)
nrf_fg <- pct_dv_food_groups %>%
  group_by(fdc_id) %>%
  #calculate fg component of hybrid nutrient density score
  mutate("nrf_fg" = round(sum(pct_dv_per_100kcal)))

# nrf 6.3, hybrid nrf 
nrf <- nrf_63 %>%
  left_join(nrf_fg, by="fdc_id") %>%
  mutate("nrf_hybrid" = nrf_63 + nrf_fg) %>% 
  select(fdc_id,
         description,
         nrf_63,
         nrf_hybrid) 

###############################################################################
# OUTPUT CSVS

write.csv(nrf, "C:/Users/Owner/repos/nutrition_dashboard/data/nutrient_density_score.csv", row.names = FALSE)
write.csv(pct_dv, "C:/Users/Owner/repos/nutrition_dashboard/data/percent_daily_value.csv", row.names = FALSE)
