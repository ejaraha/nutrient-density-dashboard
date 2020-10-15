library(dplyr)
source('C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r')


# data_types in food that have food_nutrient info *both branded_food and sub_sample_food also have entries that don't have nutrient info
left_join(food, food_nutrient, by="fdc_id") %>%
  filter(is.na(id) == TRUE) %>%
  select(data_type) %>%
  distinct()

# data_types in food that do not have food_nutrient info
left_join(food, food_nutrient, by="fdc_id") %>%
  filter(is.na(id) != TRUE) %>%
  select(data_type) %>%
  distinct()

# 67 observations in branded_food that don't have nutrient info
left_join(food, food_nutrient, by="fdc_id") %>%
  filter(is.na(id) == TRUE & data_type == "branded_food") %>%
  glimpse()

# variables where food$food_category_id is null
food %>%
  filter(is.na(food_category_id) == TRUE) %>%
  select(data_type) %>%
  distinct()

# variables where food$food_category_id is not null
food %>%
  filter(is.na(food_category_id) != TRUE) %>%
  select(data_type) %>%
  distinct()

# branded_food has 236 distinct categories
branded_food %>% select(branded_food_category) %>% distinct()
