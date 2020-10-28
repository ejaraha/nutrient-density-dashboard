library(tidyverse)
setwd("C:/Users/Owner/repos/nutrition_dashboard/data")

#food data central
food <- read.csv("fdc/food.csv", stringsAsFactors = FALSE)
fndds_survey <- read.csv("fdc/survey_fndds_food.csv", stringsAsFactors = FALSE)
food_nutrient <- read.csv("fdc/food_nutrient.csv", stringsAsFactors = FALSE)
nutrient <- read.csv("fdc/nutrient.csv", stringsAsFactors = FALSE)

#food pattern equivalents database
food_equivalent <- read.csv("food_pattern_equivalents_database.csv", stringsAsFactors = FALSE)

#supplemental data
daily_value <- read.csv("daily_values.csv", stringsAsFactors = FALSE)
fg_rec_nrf_dga <- read.csv("food_group_nrf_dga.csv", stringsAsFactors = FALSE)






