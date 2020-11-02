library(tidyverse)
setwd("C:/Users/Owner/repos/nutrition_dashboard/data/raw")

#food data central
food <- read.csv("fdc/food.csv", stringsAsFactors = FALSE)
fndds_survey <- read.csv("fdc/survey_fndds_food.csv", stringsAsFactors = FALSE)
food_nutrient <- read.csv("fdc/food_nutrient.csv", stringsAsFactors = FALSE)
nutrient <- read.csv("fdc/nutrient.csv", stringsAsFactors = FALSE)

#food pattern equivalents database
food_equivalent <- read.csv("food_pattern_equivalents_database.csv", stringsAsFactors = FALSE)

#supplemental data
# daily_value_nutrient <- read.csv("daily_value_nutrient.csv", stringsAsFactors = FALSE)
# daily_value_food_group <- read.csv("daily_value_food_group.csv", stringsAsFactors = FALSE)
daily_recommendation <- read.csv("daily_recommendation.csv", stringsAsFactors = FALSE)




