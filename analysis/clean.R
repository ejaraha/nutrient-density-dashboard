source("C:/Users/Owner/repos/nutrition_dashboard/analysis/import.r")
source("C:/Users/Owner/repos/nutrition_dashboard/analysis/functions.r")

## select necessary columns

food <- food %>%
  select(fdc_id,
         data_type,
         description)

fndds_survey <- fndds_survey %>% 
  select(fdc_id,
         food_code)

food_nutrient <- food_nutrient %>%
  select(id,
         fdc_id,
         nutrient_id,
         amount)

nutrient <- nutrient %>% 
  select(id,
         name,
         unit_name)

food_equivalent <- food_equivalent %>%
  select(FOODCODE,
         DESCRIPTION,
         F_TOTAL,
         V_TOTAL,
         G_WHOLE,
         G_TOTAL,
         PF_TOTAL,
         PF_NUTSDS,
         D_TOTAL)

## check for nulls and empty spaces
# print("checking for nulls and empty spaces")

# check_empty_glimpse(food)
# check_empty_glimpse(fndds_survey)
# check_empty_glimpse(food_nutrient)
# check_empty_glimpse(nutrient)
# check_empty_glimpse(daily_value_nutrient)
# check_empty_glimpse(daily_value_food_group)
# check_empty_glimpse(food_equivalent)

## handle  nulls
print("handling nulls...")

food <- food %>%
  mutate(description = na_if(description,""))

# check_empty_glimpse(food)




