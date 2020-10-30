library(shiny)
library(rhandsontable)
library(shinythemes)

setwd("C:/Users/Owner/repos/nutrition_dashboard/data/")

nutrient_density_score <- read.csv("nutrient_density_score.csv", stringsAsFactors = FALSE)
daily_value <- read.csv("percent_daily_value.csv",stringsAsFactors = FALSE)

ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  navbarPage(
    "Nutrient Density Dashboard",
    id = "main",
    
    tabPanel(
      "Foods",
      fluidRow(
          #input: dropdown menu to select foods
          column(width = 12,
               selectizeInput(inputId = "food",
                           label = "Select foods:",
                           choices = nutrient_density_score$description,
                           multiple = TRUE))
      ),
      
      fluidRow(
        #output: handsontable
        column(width = 12,
               rHandsontableOutput(outputId = "select_foods"))
      ),
      
      fluidRow(
        #output: %DV bar chart
        column(width = 6,
               plotOutput(outputId = "pct_dv")),
        #output: nutrient density score bar chart
        column(width = 6, offset = 6,
               plotOutput(outputId = "nd_score"))
      )
      
    ),
    
    tabPanel(
      "Food Groups",
      
      fluidRow(
        #input: food group radio boxes
        column(width = 4,
               radioButtons(inputId = "select_food_group",
                            label = "Select a food group:",
                            choices = unique(nrf$food_group))
               ),
        #output: nrf 6.3 histogram
        column(width = 8, offset = 4,
               plotOutput(outputId = "hist_nrf_63"))
      ),
      
      fluidRow(
        #output: nrf hybrid histogram
        column(width = 8, offset = 4,
               plotOutput(outputId = "hist_nrf_hybrid"))
      )
    ),
    
    tabPanel(
      "About the Data",
      p("This data is from the Food and Nutrition Database for Dietary Studies (FNDDS) and the Food Pattern Equivalent Database (FPED)."),
      fluidRow(
        #output: nutrient density score data table
        column(width = 12,
               dataTableOutput(outputId = "data_nrf"))
      ),
      
      fluidRow(
        #output: percent daily value data table
        column(width = 12,
               dataTableOutput(outputId = "data_dv"))
      )
    )
  )
)

server <- function(input, output){}

shinyApp(ui=ui, server=server)
