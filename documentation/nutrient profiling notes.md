[toc]



# A proposed nutrient density score that includes food groups and nutrients to better align with dietary guidance

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6489166/

2019

## Abstract

- The Dietary Guidelines for Americans (DGA) have adopted a more food-group-based approach.
  - By contrast, most nutrient profiling (NP) models continue to assess nutrient density of individual foods based on a small number of individual nutrients. (9 to encourage and 3 to limit)
- since current NP models may not fully capture the healthfulness of foods, there is a case for advancing a hybrid NP approach that takes both nutrients and desirable food groups and food ingredients into account.
- hybrid nutrient density scores will provide for a better alignment between NP models and the DGA.

## Introduction

- The Dietary Guidelines for Americans (DGA) have been published every 5 years since 1980 by the US Department of Agriculture (USDA) and the US Department of Health and Social Services (DHSS). 
- Despite decades of dietary guidance, most American's diets do not conform to recommendations.
- The incidence of noncommunicable diseases (NCDs) is on the rise. Diet is an important modifiable risk factor.
- Proposal: broaden NP modeling approach to consider meals, menus, or diets, not only individual foods
- Future DGAs would benefit from a more quantitative approach to nutrient density
  - In the past, the NP models used have categorized foods by the *absence* of saturated fats, added sugars, and salt rather than a hybrid approach with nutrients.

## The Dietary Guidelines for Americans

![2019](C:\Users\Owner\repos\nutrition_dashboard\documentation\supporting docs\2019.PNG)

# Whole grain contribution to US diet

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5331584/pdf/nutrients-09-00153.pdf



![image-20201025162747371](C:\Users\Owner\AppData\Roaming\Typora\typora-user-images\image-20201025162747371.png)

# Nutrient density: principles and evaluation tools

https://academic.oup.com/ajcn/article/99/5/1223S/4577490

2014

## Abstract 

- Nutrient profiling: 
  - the technique of rating or classifying foods on the basis of their nutritional value
  - calculated per 100g, 100 kcal, or per serving size of food
- nutrient dense: foods that supply relatively more nutrients than calories
- restates findings from "Development and validation of the nutrient-rich foods index: a tool to measure nutritional quality of foods" (above)

## Introduction

- beneficial nutrients:

  - protein, dietary fiber, vitamins, minerals
- nutrients to limit:

  - free or added sugars, saturated fat, sodium
- given that most foods provide multiple nutrients, developing a formal quantitative system to rate the overall nutritional value of individual foods poses challenges both scientifically and communicatively.
- nutrient profiling helps identify foods that are nutrient rich, affordable, and sustainable
  - the inclusion of food prices in nutrient density calculations has allowed researchers to create new metrics of affordability to identify the foods that provide the most nutrients per penny
  - including data on greenhouse gas emissions helps rank foods based on their carbon footprint and nutrients.


## Nutrient-Rich Foods Index

- reference DVs chosen based on 2000 kcal diet

- nutrient contents of foods were converted to %DVs per reference amount and capped at 100% so that foods containing very large amounts of a single nutrient would not obtain a disproportionately high index score

   1. calculate sub components: NRn, LIM

      - sum(%DV in 100 g of each nutrient in a food)

      - $$
        NR_{sum} = \sum_{1-n} (\frac{Nutrient_i}{DV_i})*100
        $$

        

      - OR

      - mean(%DV in 100 g of each nutrient in a food))

      $$
      NR_{mean} = \frac{\sum_{1-n} (\frac{Nutrient_i}{DV_i})*100}{n}
      $$

      

   2. calculate sub components per reference amount: 100 kcal, RACC

      - %DV nutrients per reference amount of a food

      - per 100 kcal

      - $$
        \frac{NR_n}{100kcal} = \frac{NR_n}{ED}*100
        $$

      - $$
        ED = \frac{kcal}{100g}
        $$

      - OR

      - per RACC

      - $$
        \frac{NR_n}{RAC} = \frac{NR_n}{100}*RACC
        $$

        

   3. calculate food score

      - $$
        FoodScore = NR_n - LIM
        $$

        

   Reference DVs for NR and LIM

   | nutrient      | DV based on 2000 kcal diet |
   | ------------- | -------------------------- |
   | protein       | 50 g                       |
   | fiber         | 25 g                       |
   | vitamin A     | 5000 IU                    |
   | vitamin C     | 60 mg                      |
   | vitamin E     | 30 IU                      |
   | calcium       | 1000 mg                    |
   | iron          | 18 mg                      |
   | potassium     | 3500 mg                    |
   | magnesium     | 400 mg                     |
   | saturated fat | 20 g                       |
   | added sugar   | 50 g                       |
   | sodium        | 2400 mg                    |
   

RACC values 

| category                      | RACC  |
| ----------------------------- | ----- |
| sugar                         | 4 g   |
| fats and oils                 | 15 g  |
| cheeses                       | 30 g  |
| meats                         | 85 g  |
| vegetables and fruit          | 120 g |
| yogurt                        | 220 g |
| milk, juices, other beverages | 240 g |


### Interpretation

| base         | foods that benefitted most                                   |
| ------------ | ------------------------------------------------------------ |
| 100 kcal     | low-energy-dense vegetables, salad greens ex. spinach, lettuce, endive, cabbage, watercress |
| 100 g        | energy-dense foods, notably nuts and seeds, protein powder, fortified cereals |
| serving size | foods consumed in amounts >100g (fruit, fruit juices, cooked vegetables and juices, milk and yogurts, other beverages and mixed foods). by contrast, foods consumed in amounts <100g received lower scores ex. nuts and seeds, fortified cereals |



# Development and validation of the nutrient-rich foods index: a tool to measure nutritional quality of foods

https://pubmed.ncbi.nlm.nih.gov/19549759/

https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfcfr/cfrsearch.cfm?fr=101.12

2009

## Abstract

- A family of nutrient-rich foods (NRF) indices were validated against the Healthy Eating Index (HEI)
  - HEI is an accepted measure of diet quality
  - the winning NRF index was based on 9 nutrients to encourage and 3 LIM per [(reference amounts customarily consumed (RACC))](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfcfr/cfrsearch.cfm?fr=101.12) and per 100 kcal. 
- Foods consumed by participants in NHANES 1999-2002 studies were scored using NRF indices
- NRF indices were based on unweighted sums, means, and ratios of percent daily values (DV) for [1] (n) nutrients to encourage and [2] (LIM) nutrients to limit.
  - algorithms based on sums or means of nutrient DV performed better than ratio-based scores
- Individual food scores were calculated based on 100 kcal and FDA serving sizes RACC
  - the NRF indices based on 100 kcal performed similarly to indices based on RACC
- Energy-weighted food-based scores per person were then regressed against HEI, adjusting for gender, age, and ethnicity. 
- The measure of index performance was the percentage of variation in HEI (R^2) explained by each NRF score.
  - NRF indices based on both n and LIM performed better than indices based on LIM only
  - maximum variance in HEI was explained using 6 or 9 nutrients to encourage
  - index performance declined with the inclusion of additional vitamins and minerals

## Introduction

- diet quality indices assess the overall nutritional quality of the total diet
- food nutritional quality indices are intended to measure nutrient quality of individual foods.
- In the EU, criteria for health claims (regulated indicator of healthiness) is being developed
- In the US, nutrition and health claims have existed for some time
  - foods that exceed predefined levels of total fat, saturated fat, cholesterol, or sodium cannot be deemed healthy
  - foods must also provide >= 10% of the daily value (DV) of protein, fiber, vitamin A, vitamin C, calcium, or iron
- creating a composite nutritional quality index raises some methodological issues
  - selection of nutrients
  - choice of reference DV
  - choice of reference amounts (100g, 100kcal, serving size)
  - validation against an accepted independent measure of diet quality
- indices were selected based on their ability to explain the percent of variation (R^2) when compared against the HEI. 
  - top performing indices were further characterized by examining scores on a food group basis.

## Methods

![image-20201018223904016](C:\Users\Owner\AppData\Roaming\Typora\typora-user-images\image-20201018223904016.png)

- The 2005 Dietary Guidelines for Americans (DGA) have identified additional nutrients of concern that are underrepresented in the typical US diet.
  - adults: fiber, vitamins A, C, E, calcium, potassium, and magnesium.
  - children: fiber, vitamin E, calcium, potassium, and magnesium.
  - specific population groups: B-12, iron, folic acid, vitamin D
- based on saturated fat, added sugar, and sodium
  - previous works indicate that energy, total fats, and saturated fats are highly correlated with each other. total and added sugars are also highly correlated with each other. Sodium is independent of sugar and fats.
- indices were calculated as 
  1. the sum of nutrients to encourage minus the sum of nutrients to LIM
  2. the mean of nutrients to encourage minus the mean of LIM
  3. the ratio of nutrients to encourage : LIM
- In all indices (sum, mean, ratio) nutrient amounts were calculated as a percent of reference DV. LIM reference values were 20g saturated fat, 50g added sugar, and 2400 mg sodium in a 2000 kcal per day diet. 

# Should nutrient profiles be based on 100g, 100kcal, or serving size

https://www.nature.com/articles/ejcn200853

2008

## old

## HEI 

https://epi.grants.cancer.gov/hei/calculating-hei-scores.html

https://epi.grants.cancer.gov/hei/comparing.html

https://www.fns.usda.gov/how-hei-scored

so they calculated the HEI (by food group --> health score) and the NRF index (by nutrient density --> health score) then adjusted the NRF to match the HEI for foods consumed by participants in the NHANES 1999-2002





















































