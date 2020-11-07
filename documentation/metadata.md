[toc]

# clean

## food

| variable    | description                                                  |
| ----------- | ------------------------------------------------------------ |
| fdc_id      | food data central id                                         |
| data_type   | dataset of food data central (fndds, branded foods, foundation foods) |
| description | food name                                                    |



## fndds_survey

| variable  | description                         |
| --------- | ----------------------------------- |
| fdc_id    | food data central id                |
| food_code | food pattern equivalent database id |



## food_nutrient

| variable    | description              |
| ----------- | ------------------------ |
| id          | unique id                |
| fdc_id      | food data central id     |
| nutrient_id | nutrient id              |
| amount      | amount nutrient per 100g |

## nutrient

| variable  | description   |
| --------- | ------------- |
| id        | nutrient_id   |
| name      | nutrient name |
| unit_name | nutrient unit |



## food_equivalent

| variable    | description                         |
| ----------- | ----------------------------------- |
| foodcode    | food pattern equivalent database id |
| description | food name                           |
| f_total     | amount fruits per 100g              |
| v_total     | amount vegetables per 100g          |
| g_whole     | amount whole grains per 100g        |
| g_total     | amount grains per 100g              |
| pf_total    | amount protein foods per 100g       |
| pf_nutsds   | amount nuts and seeds per 100g      |
| d_total     | amount dairy per 100g               |



## daily_recommendation

| variable                  | description                                                |
| ------------------------- | ---------------------------------------------------------- |
| id                        | unique id for component of nutrient density score          |
| component_name            | component of nutrient density score                        |
| daily_recommendation      | daily recommendation amount                                |
| daily_recommendation_unit | unit                                                       |
| component_type            | "nutrient to encourage", "nutrient to limit", "food group" |

# wrangle

## energy

| variable        | description                          |
| --------------- | ------------------------------------ |
| fdc_id          | food data central id                 |
| food_code       | food pattern equivalents database id |
| energy_per_100g | energy per 100g                      |
| energy_unit     | kcal                                 |



## food_group

| variable    | description                         |
| ----------- | ----------------------------------- |
| food_code   | food pattern equivalent database id |
| description | name of food                        |
| food_group  | food group of food                  |



## pct_daily_rec

| variable                  | description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| fdc_id                    | food data central id                                         |
| description               | name of food                                                 |
| component_name            | name of nutrient or food group                               |
| component_type            | "nutrient to encourage", "nutrient to limit", "food group"   |
| pct_daily_rec_per_100kcal | percent of daily recommendation fulfilled by a food for each component |

## nutrient_density_score

| variable    | description                       |
| ----------- | --------------------------------- |
| fdc_id      | description                       |
| description | name of food                      |
| food_group  | food group                        |
| nd_63       | nutrient rich density score (6.3) |
| nd_hybrid   | hybrid nutrient density score     |

