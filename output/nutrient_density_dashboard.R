library(shiny)
library(rhandsontable)
library(shinythemes)
library(dplyr)

setwd("C:/Users/Owner/repos/nutrition_dashboard/data/")

nutrient_density_score <- read.csv("nutrient_density_score.csv", stringsAsFactors = FALSE)
pct_daily_rec <- read.csv("percent_daily_recommendation.csv",stringsAsFactors = FALSE)
initial_food_selection <- "milk, nfs"

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
                           choices = nutrient_density_score$description,
                           selected = initial_food_selection)),
          column(width = 2,
                 numericInput(inputId = "calories",
                              label = "Calories:",
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
      
      br(),
      
      fluidRow(
        #output: table to display foods and calories
        column(width = 12,
               tableOutput(outputId = "food_table"))
      ),
      
      fluidRow(
        #TEST
        column(width = 12,
               tableOutput(outputId = "test_table"))
      ),
      
      fluidRow(
        #output: %DV bar chart
        column(width = 6,
               plotOutput(outputId = "pct_daily_rec")),
        #output: nutrient density score bar chart
        column(width = 6, 
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
                            choices = unique(nutrient_density_score$food_group))
               ),
        #output: nrf 6.3 histogram
        column(width = 8, offset = 1,
               plotOutput(outputId = "hist_nd_63"))
      ),
      
      fluidRow(
        #output: nrf hybrid histogram
        column(width = 8, offset = 4,
               plotOutput(outputId = "hist_nd_hybrid"))
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
  
  # initialize dataframe for input$select_food
  food_cal <- data.frame("description"=c(initial_food_selection), "calories"=c(100))
  # make dataframe reactive so it updates when the values change
  food_cal_values <- reactiveValues(data = food_cal)
  
  # when "add" button is pressed, bind selection to food_cal_values
  observeEvent(input$add_food,
               #get current value of food_cal_values
                {food_cal_current <- food_cal_values$data
                #alter food_cal_values
                food_cal_new <- bind_rows(food_cal_current,
                                            data.frame("description" = input$select_food,
                                                       "calories" = input$calories))
                #update food_cal_values with new values
                food_cal_values$data <- food_cal_new})
  
  # when "remove" button is pressed, remove selection from food_cal_values
  observeEvent(input$remove_food,
               #get current value of food_cal_values
                {food_cal_current <- food_cal_values$data
                #check if food_cal_current contains the input to be removed 
                check_exists <- nrow(food_cal_current[which(food_cal_current$description == input$select_food
                                       & food_cal_current$calories == input$calories),])
                #only alter food_cal_values if food_cal_current contains the input to be removed
                if(check_exists != 0){
                food_cal_new <- food_cal_current[-which(food_cal_current$description == input$select_food
                                                        & food_cal_current$calories == input$calories),]
                #update food_cal_values with new values
                food_cal_values$data <- food_cal_new}
                })

  output$food_table <- renderTable({food_cal_values$data})
  
  #output$test_table <- renderTable({df_()})
}


shinyApp(ui=ui, server=server)
