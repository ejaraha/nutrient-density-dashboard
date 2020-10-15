library(dplyr)
setwd("C:/Users/Owner/repos/nutrition_dashboard/data/raw")

#body
food <- read.csv("food.csv", stringsAsFactors = FALSE)
foundation_food <- read.csv("foundation_food.csv", stringsAsFactors = FALSE)
branded_food <- read.csv("branded_food.csv", stringsAsFactors = FALSE)
market_acquisition <- read.csv("market_acquisition.csv", stringsAsFactors = FALSE)
#meta
food_category <- read.csv("food_category.csv", stringsAsFactors = FALSE)
food_nutrient <- read.csv("food_nutrient.csv", stringsAsFactors = FALSE)
nutrient <- read.csv("nutrient.csv", stringsAsFactors = FALSE)
food_nutrient_conversion_factor <- read.csv("food_nutrient_conversion_factor.csv", stringsAsFactors = FALSE)
food_calorie_conversion_factor <- read.csv("food_calorie_conversion_factor.csv", stringsAsFactors = FALSE)
food_nutrient_derivation <- read.csv("food_nutrient_derivation.csv", stringsAsFactors = FALSE)
food_nutrient_source <- read.csv("food_nutrient_source.csv", stringsAsFactors = FALSE)

glimpse(food_nutrient_source)
glimpse(food_nutrient_derivation)
glimpse(food_calorie_conversion_factor)
glimpse(food_nutrient_conversion_factor)
glimpse(nutrient)
glimpse(food_nutrient)
glimpse(food_category)
glimpse(market_acquisition)
glimpse(branded_food)
glimpse(foundation_food)
glimpse(food)


#nrf calculation
food_nutrient %>% 
  left_join(nutrient, by=c("nutrient_id"="id")) %>% 
  left_join(food_nutrient_conversion_factor, by=c("fdc_id")) %>%
  left_join(food_calorie_conversion_factor, by=c("id.y"="food_nutrient_conversion_factor_id")) %>%
  select(id.x,
         fdc_id,
         name,
         amount,
         protein_value,
         fat_value,
         carbohydrate_value) %>%
  glimpse()

#nrf food descriptions
food %>% 
  left_join(branded_food, by="fdc_id") %>%
  left_join(food_category, by=c("food_category_id"="id")) %>%
  select(fdc_id,
         data_type,
         description.y,
         brand_owner,
         branded_food_category) %>%
  glimpse()

#data_points
food_nutrient %>%
  left_join(nutrient, by=c("nutrient_id"="id")) %>%
  select(fdc_id, 
         nutrient_id,
         name,
         data_points) %>%
  filter(is.na(data_points) != TRUE) %>%
  #arrange(desc(data_points)) %>%
  glimpse()

#market_acquisition
market_acquisition %>%
  select(fdc_id,
         brand_description,
         store_city,
         store_name,
         store_state) %>%
  glimpse()


  
  
  

