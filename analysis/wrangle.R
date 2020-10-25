source("C:/Users/Owner/repos/nutrition_dashboard/analysis/clean.r")

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

df <- nrf %>% filter(grepl("2%", description) == TRUE
                    & grepl("2%", description) == TRUE)
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

food %>% 
  filter(fdc_id %in% data_points$fdc_id) %>%
  distinct(data_type)

