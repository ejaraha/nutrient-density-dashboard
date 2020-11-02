library(shiny)
library(rhandsontable)
library(shinythemes)
library(dplyr)

setwd("C:/Users/Owner/repos/nutrition_dashboard/data/")

nutrient_density_score <- read.csv("nutrient_density_score.csv", stringsAsFactors = FALSE)
daily_value <- read.csv("percent_daily_recommendation.csv",stringsAsFactors = FALSE)

ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  navbarPage(
    "Nutrient Density Dashboard",
    id = "main",
    
    tabPanel(
      "Foods",
      fluidRow(
          #input: dropdown menu to select foods
          column(width = 4,
               selectInput(inputId = "select_food",
                           label = "Food:",
                           choices = nutrient_density_score$description)),
          column(width = 2,
                 numericInput(inputId = "calories",
                              label = "Calories",
                              value = 100,
                              step = 50)),
      ),
      
      fluidRow(
        column(width = 1,
               actionButton(inputId = "add_food",
                            label = "add")),
        column(width = 2,
               actionButton(inputId = "remove_food",
                            label = "remove"))
      ),
      
      fluidRow(
        #output: handsontable
        column(width = 12,
               tableOutput(outputId = "food_table"))
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
                            choices = unique(daily_value$component))
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


server <- function(input, output){
  
  # data frame of nutrient_density_score filtered by input$select_food
  df <- reactive({nutrient_density_score %>%
      filter(description %in% input$select_food) %>%
      mutate("calories"=100) %>%
      select(description, calories)})
  
  # datavalues <- reactiveValues(data = data.frame(df())) 
  
  output$food_table <- renderTable({df()})
}


shinyApp(ui=ui, server=server)
