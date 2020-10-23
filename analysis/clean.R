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

nrf_calculation <- food_nutrient %>% 
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  mutate(unit_name = tolower(unit_name)) %>%
  rename(nutrient_name = name,
         nutrient_per_100g = amount,
         nutrient_unit = unit_name) %>%
  filter(nutrient_name %in% c("Calcium, Ca",
                              "Iron, Fe",
                              "Potassium, K",
                              "Protein",
                              "Fiber, total dietary",
                              #use vitamin d *IU* because 6,226 foods have observations for vitamin d IU vs 5 foods for vit d mg
                              "Vitamin D (D2 + D3), International Units",
                              "Sodium, Na",
                              "Sugars, Total NLEA",
                              "Fatty acids, total saturated",
                              "Energy")) %>%
  select(id,
         fdc_id,
         nutrient_name,
         nutrient_per_100g,
         nutrient_unit)

nrf_food_descriptions <- food %>% 
  left_join(branded_food, by="fdc_id") %>%
  left_join(food_category, by=c("food_category_id"="id")) %>% 
  mutate(description.y = replace_na(description.y, "")) %>%
  unite("food_category", description.y, branded_food_category, sep="") %>%
  mutate_at(c("food_category", 
              "description.x"), ~na_if(tolower(.), "")) %>%
  rename("description" = description.x) %>%
  select(fdc_id,
         data_type,
         description,
         food_category)

data_points <- food_nutrient %>%
  left_join(nutrient, by=c("nutrient_id"="id")) %>%
  left_join(food_nutrient_derivation, by = c("derivation_id"="id")) %>%
  left_join(food_nutrient_source, by=c("source_id"="id")) %>%
  select(fdc_id, 
         nutrient_id,
         name,
         data_points,
         description.x,
         description.y) %>%
  rename(nutrient_name = name,
         nutrient_source = description.y,
         nutrient_derivation = description.x) %>%
  filter(is.na(data_points) != TRUE)

market_acquisition <- market_acquisition %>%
  # replace "" with NA, rename variables
  mutate_at(c("brand_description", 
              "store_city", 
              "store_name", 
              "store_state"), ~na_if(.,"")) %>%
  rename(brand = brand_description) %>%
  select(fdc_id,
         brand,
         store_city,
         store_name,
         store_state)

hei <- hei %>%
  mutate(unit = na_if(unit, ""))
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


