source("C:/Users/Owner/repos/nutrition_dashboard/analysis/preclean.r")

# check_na <- function(df){
#   apply(df, 2, function(df) any(is.na(df))) 
# }
# 
# check_empty <- function(df){
#   apply(df, 2, function(df) any(df == "")) 
# }

# # check nulls and empty spaces
# 
# glimpse(nrf_calculation)
# check_empty(nrf_calculation)
# check_na(nrf_calculation)
# 
# glimpse(nrf_food_descriptions)
# check_empty(nrf_food_descriptions)
# check_na(nrf_food_descriptions)
# 
# glimpse(data_points)
# check_empty(data_points)
# check_na(data_points)
# 
# glimpse(market_acquisition)
# check_empty(market_acquisition)
# check_na(market_acquisition)


nrf_calculation <- nrf_calculation %>% 
  # rename columns and replace "" with NAs
  rename(id = id.x,
         nutrient_name = name,
         nutrient_amount = amount,
         nutrient_unit = unit_name,
         protein_calorie_conversion_factor = protein_value,
         fat_calorie_conversion_factor = fat_value,
         carb_calorie_conversion_factor = carbohydrate_value) 

nrf_food_descriptions <- nrf_food_descriptions %>% 
  # rename columns, create $food_category replace "" with NAs  
  mutate(description.y = replace_na(description.y, "")) %>%
  unite("food_category", description.y, branded_food_category, sep="") %>%
  mutate(food_category = na_if(food_category, ""))

market_acquisition <- market_acquisition %>%
  # replace "" with NA, rename variables
  mutate_at(c("brand_description", 
              "store_city", 
              "store_name", 
              "store_state"), ~na_if(.,"")) %>%
  rename(brand = brand_description)

data_points <- data_points %>%
  rename(nutrient_name = name) 



