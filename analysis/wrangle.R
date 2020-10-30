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

# nrf_fg (fg component of hybrid nrf)
var_nrf_fg <- food_equivalent %>%
  rename("food_code" = FOODCODE,
         "description" = DESCRIPTION,
         "fruits" = F_TOTAL,
         "vegetables" = V_TOTAL,
         "whole_grains" = G_WHOLE,
         "grains" = G_TOTAL,
         "protein_foods" = PF_TOTAL,
         "nuts_and_seeds" = PF_NUTSDS,
         "dairy" = D_TOTAL) %>%
  pivot_longer(cols = !c("food_code", "description"),
               names_to = "food_group",
               values_to = "equivalents_per_100g") %>%
  mutate("nrf_fg_id" = case_when(food_group == "whole_grains" ~1,
                           food_group == "vegetables" ~2,
                           food_group =="fruits" ~3,
                           food_group == "dairy" ~4,
                           food_group == "nuts_and_seeds" ~5),
         "equivalent_unit" = case_when(food_group == "whole_grains" ~"oz",
                                       food_group == "vegetables" ~"cup",
                                       food_group =="fruits" ~"cup",
                                       food_group == "dairy" ~"cup",
                                       food_group == "nuts_and_seeds" ~"oz",
                                       food_group == "protein_foods" ~"oz",
                                       food_group == "grains" ~"oz"),
         food_group = str_replace_all(food_group, "_", " "),
         description = tolower(description)) %>%
  left_join(daily_value_food_group, by="nrf_fg_id") %>%
  left_join(energy, by="food_code")


# nrf6.3
var_nrf_63 <- food %>%
  # fndds foods only
  filter(data_type == "survey_fndds_food") %>%
  # nutrient amounts
  left_join(all_of(food_nutrient), by="fdc_id") %>% 
  # nutrient names and units
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  # energy content per food (kcal)
  left_join(all_of(energy), by="fdc_id") %>%
  # clean names
  rename(nutrient_name = name,
         nutrient_per_100g = amount,
         nutrient_unit = unit_name) %>% 
  mutate(nutrient_unit = tolower(nutrient_unit),
         "description" = tolower(description),
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
         # convert units
         nutrient_per_100g = case_when(nutrient_unit == "iu" ~nutrient_per_100g*0.025,
                                       TRUE ~as.double(nutrient_per_100g)),
         nutrient_unit = case_when(nutrient_unit == "iu" ~"mcg",
                                   TRUE ~nutrient_unit)) %>% 
  # daily values
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

# nutrients
pct_dv_nutrients <- var_nrf_63 %>%
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

# food groups
pct_dv_food_groups <- var_nrf_fg %>%
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
  mutate("nrf_fg" = round(sum(pct_dv_per_100kcal))) %>% 
  #food group for each food = food group with highest %DV for that food
  filter(pct_dv_per_100kcal == max(pct_dv_per_100kcal)) %>% 
  rename("food_group" = component) %>%
  #handle foods that are not in a food group (human milk, oil)
  filter(food_group == max(food_group)) %>%
  mutate(food_group = case_when(nrf_fg == 0 ~NA_character_,
                                TRUE ~ food_group)) %>%
  select(-pct_dv_per_100kcal) 


# nrf 6.3, hybrid nrf 
nrf <- nrf_63 %>%
  left_join(nrf_fg, by="fdc_id") %>%
  mutate("nrf_hybrid" = nrf_63 + nrf_fg) %>% 
  select(fdc_id,
         description,
         food_group,
         nrf_63,
         nrf_hybrid) 

###############################################################################
# OUTPUT CSVS

write.csv(nrf, "C:/Users/Owner/repos/nutrition_dashboard/data/nutrient_density_score.csv", row.names = FALSE)
write.csv(pct_dv, "C:/Users/Owner/repos/nutrition_dashboard/data/percent_daily_value.csv", row.names = FALSE)
