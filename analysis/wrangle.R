source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

energy <- food_nutrient %>% 
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  filter(name == "Energy" & unit_name == "KCAL") %>%
  rename("energy_per_100g" = amount,
         "energy_unit" = unit_name) %>%
  mutate(energy_unit = tolower(energy_unit)) %>%
  select(fdc_id,
         energy_per_100g,
         energy_unit) 

food_equivalent <- food_equivalent %>%
  rename("foodcode" = FOODCODE,
         "description" = DESCRIPTION,
         "fruits" = F_TOTAL,
         "vegetables" = V_TOTAL,
         "whole_grains" = G_WHOLE,
         "grains" = G_TOTAL,
         "protein_foods" = PF_TOTAL,
         "nuts_and_seeds" = PF_NUTSDS,
         "dairy" = D_TOTAL) %>%
  pivot_longer(cols = !c("foodcode", "description"),
               names_to = "food_group",
               values_to = "equivalents_per_100g") %>%
  mutate("nrf_fg_id" = case_when(food_group == "whole_grains" ~1,
                           food_group == "vegetables" ~2,
                           food_group =="fruits" ~3,
                           food_group == "dairy" ~4,
                           food_group == "nuts_and_seeds" ~5),
         "equivalent_unit" = case_when(food_group == "whole_grains" ~"oz",
                                       food_group == "vegetables" ~"cup",
                                       food_group =="fruits" ~"cup",
                                       food_group == "dairy" ~"cup",
                                       food_group == "nuts_and_seeds" ~"oz",
                                       food_group == "protein_foods" ~"oz",
                                       food_group == "grains" ~"oz"),
         food_group = str_replace_all(food_group, "_", " ")) 

nrf_variables <- food %>%
  # fndds foods only
  filter(data_type == "survey_fndds_food") %>%
  # nutrient amounts
  left_join(all_of(food_nutrient), by="fdc_id") %>% 
  # nutrient names and units
  left_join(all_of(nutrient), by=c("nutrient_id"="id")) %>%
  # food group crossover
  left_join(all_of(fndds_survey), by="fdc_id") %>%
  # food groups fped
  left_join(all_of(food_equivalent), by=c("food_code"="foodcode")) %>%
  # food groups and dga daily recommendations
  left_join(all_of(food_group_nrf_dga), by="nrf_fg_id") %>%
  # energy content per food (kcal)
  left_join(all_of(energy), by="fdc_id") %>%
  # clean names
  rename(nutrient_name = name,
         nutrient_per_100g = amount,
         nutrient_unit = unit_name) %>% 
  mutate(nutrient_unit = tolower(nutrient_unit),
         "description" = tolower(description.x),
         nutrient_name = case_when(nutrient_name == "Calcium, Ca" ~"calcium",
                                   nutrient_name == "Fatty acids, total saturated" ~"saturated fat",
                                   nutrient_name == "Fiber, total dietary" ~"dietary fiber",
                                   nutrient_name == "Iron, Fe" ~"iron",
                                   nutrient_name == "Potassium, K" ~"potassium",
                                   nutrient_name == "Protein" ~"protein",
                                   nutrient_name == "Sodium, Na" ~"sodium",
                                   nutrient_name == "Sugars, Total NLEA" ~"total sugars",
                                   nutrient_name == "Vitamin D (D2 + D3), International Units" ~"vitamin d",
                                   TRUE ~nutrient_name),
         # assign id for nrf nutrients to aid in joining daily values
         nutrient_id = case_when(nutrient_name == "protein" ~1,
                                 nutrient_name == "dietary fiber" ~2,
                                 nutrient_name == "vitamin d" ~3,
                                 nutrient_name == "potassium" ~4,
                                 nutrient_name == "calcium" ~5,
                                 nutrient_name == "iron" ~6,
                                 nutrient_name == "sodium" ~7,
                                 nutrient_name == "total sugars" ~8,
                                 nutrient_name == "saturated fat" ~9,
                                 TRUE ~9999),
         # convert units
         nutrient_per_100g = case_when(nutrient_unit == "iu" ~nutrient_per_100g*0.025,
                                       TRUE ~as.double(nutrient_per_100g)),
         nutrient_unit = case_when(nutrient_unit == "iu" ~"mcg",
                                   TRUE ~nutrient_unit)) %>% 
  # daily values
  left_join(daily_value[-2], by=c("nutrient_id"="dv_id")) %>% # daily_value[-2] to eliminate clash with nrf_variables.nutrient_name when joining
  # filter only necessary nutrients
  filter(nutrient_id %in% c(1:9)) %>%
  rename("food_group"=food_group.x) %>% 
  select(id,
         fdc_id,
         food_code,
         description,
         nutrient_name,
         nutrient_per_100g,
         nutrient_unit,
         daily_value,
         daily_value_unit,
         nutrient_type,
         energy_per_100g,
         energy_unit,
         food_group,
         equivalents_per_100g,
         equivalent_unit,
         daily_rec_dga,
         equivalent_unit_dga)


nrf <- nrf_variables %>%
  mutate(nutrient_per_100g = case_when(nutrient_type == "limit" ~ -nutrient_per_100g,
                                       TRUE ~nutrient_per_100g),
         "n" = (nutrient_per_100g/energy_per_100g/daily_value)*100*100,
         n = case_when(n > 100 ~100,
                         n < -100 ~ -100,
                         TRUE ~n)) %>%   
  group_by(fdc_id) %>%
  summarize(description = max(description),
            "nrf" = round(sum(n))) 






# 
# df <- nrf %>% filter(grepl("2%", description) == TRUE
#                     & grepl("2%", description) == TRUE)
# 
# 
# df <- nrf %>% filter(grepl("plain", description) == TRUE
#                           & grepl("yogurt", description) == TRUE
#                           & data_type == "survey_fndds_food") 
# 
# df <- nrf %>% filter(grepl("raw", description) == TRUE
#                           & grepl("broccoli", description) == TRUE
#                           & data_type == "survey_fndds_food")
# 
# df <- nrf %>% filter(grepl("rice", description) == TRUE
#                           & grepl("white", description) == TRUE
#                           & data_type == "survey_fndds_food")
# 
# df <- nrf %>% filter(grepl("vegetable", description) == TRUE
#                           & grepl("soup", description) == TRUE
#                           & grepl("canned", description) == TRUE
#                           & grepl("reduced", description) == TRUE
#                           & data_type == "survey_fndds_food") 
# 
# df <- nrf %>% filter(grepl("green", description) == TRUE
#                           & grepl("peas", description) == TRUE
#                           & grepl("canned", description) == TRUE
#                           & data_type == "survey_fndds_food") 
# 
# df <- nrf %>% filter(grepl("milk", description) == TRUE
#                           & grepl("", description) == TRUE
#                           & grepl("calcium", description) == TRUE
#                           & grepl("", description) == TRUE
#                           & data_type == "survey_fndds_food") 


