source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

###############################################################################
# ENERGY CONTENT OF EACH FOOD

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

###############################################################################
# FOOD GROUP FOR EACH FOOD

food_group <- food_group_equivalent %>%
  group_by(food_code) %>%
  #flag the max food group
  mutate("max_food_group" = case_when(food_group_per_100g == max(food_group_per_100g) ~ 1,
                                      TRUE ~0),
         #identify foods that do not have a max food group (human milk, coffee, oils, infant formula)
         "sum_max_food_group" = sum(max_food_group),
         food_group = case_when(sum_max_food_group > 1 ~"no food group",
                                TRUE ~food_group)) %>%
  filter(max_food_group == max(max_food_group)) %>%
  distinct(food_code, 
           description, 
           food_group)

###############################################################################
# PERCENT DAILY RECOMMENDATIONs (NUTRIENTS)

pct_daily_rec_nutrient <- food %>% # food names and data types
  # filter for fndds foods only
  filter(data_type == "survey_fndds_food") %>%
  # nutrient amounts
  left_join(all_of(food_nutrient), by="fdc_id") %>% 
  # nutrient names and units
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  # energy content in 100g food (kcal)
  left_join(all_of(energy), by="fdc_id") %>%
  # clean names
  rename(component_name = name,
         component_per_100g = amount,
         component_unit = unit_name) %>% 
  mutate(component_unit = tolower(component_unit),
         description = tolower(description),
         component_name = case_when(component_name == "Calcium, Ca" ~"calcium",
                                   component_name == "Fatty acids, total saturated" ~"saturated fat",
                                   component_name == "Fiber, total dietary" ~"dietary fiber",
                                   component_name == "Iron, Fe" ~"iron",
                                   component_name == "Potassium, K" ~"potassium",
                                   component_name == "Protein" ~"protein",
                                   component_name == "Sodium, Na" ~"sodium",
                                   component_name == "Sugars, total including NLEA" ~"total sugars",
                                   component_name == "Vitamin D (D2 + D3)" ~"vitamin d",
                                   TRUE ~component_name),
         # assign id for nrf components to aid in joining daily values
         component_id = case_when(component_name == "protein" ~6,
                                  component_name == "dietary fiber" ~7,
                                  component_name == "vitamin d" ~8,
                                  component_name == "potassium" ~9,
                                  component_name == "calcium" ~10,
                                  component_name == "iron" ~11,
                                  component_name == "sodium" ~12,
                                  component_name == "total sugars" ~13,
                                  component_name == "saturated fat" ~14,
                                  TRUE ~9999)) %>% 
  # daily values for each component
  left_join(daily_recommendation[,-2], by=c("component_id"="id")) %>% #drop daily_recommendation$component_name when joining to avoid renaming errors
  # filter only necessary components
  filter(component_id != 9999) %>%
  #calculate % daily recommendation per 100kcal for each nutrient of each food
  mutate("pct_daily_rec_per_100kcal" = round((component_per_100g/energy_per_100g/daily_recommendation)*100*100),
         #cap % daily values at 100%
         pct_daily_rec_per_100kcal = case_when(pct_daily_rec_per_100kcal > 100 ~100,
                               pct_daily_rec_per_100kcal < -100 ~ -100,
                               TRUE ~pct_daily_rec_per_100kcal)) %>%
  select(fdc_id,
         description,
         component_name,
         component_type,
         pct_daily_rec_per_100kcal)

###############################################################################
# PERCENT DAILY RECOMMENDATIONs (FOOD GROUPS)

pct_daily_rec_food_group <- food_group_equivalent %>% # food group equivalents in 100g of each food
  #add food_group_id for joining daily recommendations
  mutate("food_group_id" = case_when(food_group == "whole grains" ~1,
                                     food_group == "vegetables" ~2,
                                     food_group == "fruits" ~3,
                                     food_group == "dairy" ~4,
                                     food_group == "nuts and seeds" ~5)) %>%
  #dga recommended daily intake (only for food groups used in the hybrid nutrient density score)
  left_join(daily_recommendation, by=c("food_group_id"="id")) %>%
  #energy in 100g of food
  left_join(energy, by="food_code") %>%
  #rename variables for binding with variable_nutrient_score
  rename("component_per_100g"=food_group_per_100g,
         "component_unit"=unit) %>%
  #consider only food groups that contribute to the hybrid nutrient density score
  filter(is.na(component_name) != TRUE) %>%
  #calculate % daily recommendation per 100 kcal for each food group for each food
  mutate("pct_daily_rec_per_100kcal" = round((component_per_100g/energy_per_100g/daily_recommendation)*100*100),
         #cap daily values at 100%
         pct_daily_rec_per_100kcal = case_when(pct_daily_rec_per_100kcal > 100 ~100,
                                        TRUE ~pct_daily_rec_per_100kcal)) %>%
  select(fdc_id,
         description,
         component_name,
         component_type,
         pct_daily_rec_per_100kcal)
  
###############################################################################
# PERCENT DAILY RECOMMENDATIONs (NUTRIENTs & FOOD GROUPS)

pct_daily_rec <- bind_rows(pct_daily_rec_food_group, pct_daily_rec_nutrient) %>%
  arrange(fdc_id)

###############################################################################
# NUTRIENT DENSITY SCORES

nutrient_density_score_63 <- pct_daily_rec_nutrient %>%
  # negate nutrients to limit
  mutate(pct_daily_rec_per_100kcal = case_when(component_type == "nutrient to limit" ~ -pct_daily_rec_per_100kcal,
                                               TRUE ~pct_daily_rec_per_100kcal)) %>%
  # calculate nutrient density score 6.3
  group_by(fdc_id) %>%
  summarise("nd_63" = round(sum(pct_daily_rec_per_100kcal)))

food_group_score <- pct_daily_rec_food_group %>%
  #calculate the food group score for each food. this will be used to calculate the hybrid nutrient density score
  group_by(fdc_id) %>%
  summarise("food_group_score" = round(sum(pct_daily_rec_per_100kcal)))

#nd_hybrid, nd_63, food_group
nutrient_density_score <- nutrient_density_score_63 %>% 
  left_join(food_group_score, by="fdc_id") %>%
  left_join(fndds_survey, by="fdc_id") %>%
  left_join(food_group, by="food_code") %>%
  mutate("nd_hybrid" = nd_63 + food_group_score) %>% 
  select(fdc_id,
         description,
         food_group,
         nd_63,
         nd_hybrid) 

###############################################################################
# OUTPUT CSVS

write.csv(nutrient_density_score, "C:/Users/Owner/repos/nutrition_dashboard/data/nutrient_density_score.csv", row.names = FALSE)
write.csv(pct_daily_rec, "C:/Users/Owner/repos/nutrition_dashboard/data/percent_daily_recommendation.csv", row.names = FALSE)
