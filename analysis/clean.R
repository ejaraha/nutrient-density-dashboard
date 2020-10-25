source("C:/Users/Owner/repos/nutrition_dashboard/analysis/import.r")

# make intermediate tables: 
# 1} nrf_calculation
# 2} nrf_food_descriptions
# 3} data_points
# 4} market_acquisition
# 5} hei
# 6} food_equivalent
# 7} daily_value (no cleaning necessary)
# 8} food_group_dga (no cleaning necessary)

energy <- food_nutrient %>% 
  left_join(nutrient, by=c("nutrient_id"="id")) %>%
  filter(name == "Energy" & unit_name == "KCAL") %>%
  rename("energy_per_100g" = amount,
         "energy_unit" = unit_name) %>%
  mutate(energy_unit = tolower(energy_unit)) %>%
  select(fdc_id,
         energy_per_100g,
         energy_unit) 

nrf_variables <- food %>%
  filter(data_type == "survey_fndds_food") %>%
  # nutrient amounts
  left_join(all_of(food_nutrient), by="fdc_id") %>% 
  # nutrient names and units
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  # food category crossover
  left_join(all_of(fndds_survey), by="fdc_id") %>%
  # food categories
  left_join(all_of(wweia_food_category), by=c("wweia_category_code"="wweia_food_category_code")) %>%
  # food group crossover
  left_join(all_of(food_group_nrf_wweia), by="wweia_category_code") %>%  
  # food groups and dga daily reccommendations
  left_join(all_of(food_group_nrf_dga), by="fg_id") %>%
  # energy content per food (kcal)
  left_join(all_of(energy), by="fdc_id") %>%
  rename(nutrient_name = name,
         nutrient_per_100g = amount,
         nutrient_unit = unit_name,
         food_category = wweia_food_category_description) %>%
        # clean up nutrient names
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
         # convert units
         nutrient_per_100g = case_when(nutrient_unit == "iu" ~nutrient_per_100g*0.025,
                                       TRUE ~as.double(nutrient_per_100g)),
         nutrient_unit = case_when(nutrient_unit == "iu" ~"mcg",
                                   TRUE ~nutrient_unit)) %>% 
  # daily values
  left_join(daily_value[-2], by=c("nutrient_id"="dv_id")) %>% # daily_value[-2] to eliminate clash with nrf_variables.nutrient_name when joining
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
         energy_unit,
         food_category,
         food_group,
         daily_rec_dga,
         equivalent_unit)


# 
# food_equivalent <- food_equivalent %>%
#   rename("foodcode" = ï..FOODCODE,
#          "description" = DESCRIPTION) %>%
#   pivot_longer(cols = !c("foodcode", "description"),
#                names_to = c("food_goup", "food_subgroup"),
#                names_sep = "_",
#                values_to = "equivalents_in_100g")


## check for nulls and empty spaces

# check_empty_glimpse(nrf_calculation)
# check_empty_glimpse(nrf_food_descriptions)
# check_empty_glimpse(data_points)
# check_empty_glimpse(market_acquisition)
# check_empty_glimpse(hei)
# check_empty_glimpse(daily_value)
# check_empty_glimpse(food_group_dga)
# check_empty_glimpse(food_equivalent)


