source("C:/Users/Owner/repos/nutrition_dashboard/analysis/preclean.r")

nrf_calculation <- food_nutrient %>% 
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  rename(nutrient_name = name,
         amount_per_100g = amount,
         nutrient_unit = unit_name) %>%
  select(id,
         fdc_id,
         nutrient_name,
         amount_per_100g,
         nutrient_unit)

nrf_food_descriptions <- nrf_food_descriptions %>% 
  # rename columns, create $food_category replace "" with NAs  
  mutate(description.y = replace_na(description.y, "")) %>%
  unite("food_category", description.y, branded_food_category, sep="") %>%
  mutate(food_category = na_if(food_category, "")) %>%
  rename("description" = description.x)

nrf_food_descriptions <- food %>% 
  left_join(branded_food, by="fdc_id") %>%
  left_join(food_category, by=c("food_category_id"="id")) %>%
  select(fdc_id,
         data_type,
         description.x,
         description.y,
         brand_owner,
         branded_food_category)

data_points <- 
  food_nutrient %>%
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
  rename(brand = brand_description)

market_acquisition <- market_acquisition %>%
  select(fdc_id,
         brand_description,
         store_city,
         store_name,
         store_state)

dfs <- c(nrf_calculation,
         nrf_food_descriptions,
         data_points,
         market_acquisition,
         hei,
         daily_value,
         food_equivalent)

# 
# food_equivalent %>%
#   rename("foodcode" = ï..FOODCODE,
#          "description" = DESCRIPTION) %>%
#   pivot_longer(cols = !c("foodcode", "description"), 
#                names_to = c("food_goup", "food_subgroup"),
#                names_sep = "_",
#                values_to = "equivalents_in_100g") %>%
#   glimpse()


