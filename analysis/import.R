library(tidyverse)
setwd("C:/Users/Owner/repos/nutrition_dashboard/data")

#fdc body
food <- read.csv("fdc/food.csv", stringsAsFactors = FALSE)
foundation_food <- read.csv("fdc/foundation_food.csv", stringsAsFactors = FALSE)
branded_food <- read.csv("fdc/branded_food.csv", stringsAsFactors = FALSE)
market_acquisition <- read.csv("fdc/market_acquisition.csv", stringsAsFactors = FALSE)

#fdc meta
food_category <- read.csv("fdc/food_category.csv", stringsAsFactors = FALSE)
food_nutrient <- read.csv("fdc/food_nutrient.csv", stringsAsFactors = FALSE)
nutrient <- read.csv("fdc/nutrient.csv", stringsAsFactors = FALSE)
food_nutrient_derivation <- read.csv("fdc/food_nutrient_derivation.csv", stringsAsFactors = FALSE)
food_nutrient_source <- read.csv("fdc/food_nutrient_source.csv", stringsAsFactors = FALSE)

#supplemental data
daily_value <- read.csv("daily_values.csv", stringsAsFactors = FALSE)
hei <- read.csv("hei_2000_2010_2015.csv", stringsAsFactors = FALSE)
food_equivalent <- read.csv("food_patterns_equivalents_db_per_100g_of_fndds_2015_2016_foods.csv", stringsAsFactors = FALSE)






