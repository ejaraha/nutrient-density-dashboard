library(tidyverse)
setwd("C:/Users/Owner/repos/nutrition_dashboard/data")

#fdc body
food <- read.csv("fdc/food.csv", stringsAsFactors = FALSE)
fndds_survey <- read.csv("fdc/survey_fndds_food.csv", stringsAsFactors = FALSE)

#fdc meta
food_nutrient <- read.csv("fdc/food_nutrient.csv", stringsAsFactors = FALSE)
nutrient <- read.csv("fdc/nutrient.csv", stringsAsFactors = FALSE)
wweia_food_category <- read.csv("fdc/wweia_food_category.csv", stringsAsFactors = FALSE)

#supplemental data
daily_value <- read.csv("daily_values.csv", stringsAsFactors = FALSE)
food_group_nrf_dga <- read.csv("food_group_nrf_dga.csv", stringsAsFactors = FALSE)
food_group_nrf_wweia <- read.csv("food_group_nrf_wweia.csv", stringsAsFactors = FALSE)
food_equivalent <- read.csv("food_patterns_equivalents_db_per_100g_of_fndds_2015_2016_foods.csv", stringsAsFactors = FALSE)






