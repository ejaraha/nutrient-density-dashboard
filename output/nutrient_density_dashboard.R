library(shiny)
library(rhandsontable)
library(shinythemes)
library(dplyr)
library(ggplot2)

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
        #output: table to display foods, calories, and nutrient density scores
        column(width = 6,
               dataTableOutput(outputId = "food_selection")),
        #output: %DV bar chart
        column(width = 6,
               plotOutput(outputId = "pct_daily_rec"))
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
               dataTableOutput(outputId = "data_nds"))
      ),
      
      fluidRow(
        #output: percent daily value data table
        column(width = 12,
               dataTableOutput(outputId = "data_pdg"))
      )
    )
  )
)


server <- function(input, output){
  
  #############################################################################################
  # FOOD TAB
  
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
  
  # filter data from nutrient_density_score
  nutrient_density_df <- reactive({food_cal_values$data %>% 
      left_join(nutrient_density_score, by="description") %>%
      select(-c(fdc_id, food_group))})
  
  output$food_selection <- renderDataTable({nutrient_density_df()})
  
  pct_daily_rec_df <- reactive({food_cal_values$data %>%
      #filter for selected foods
      left_join(pct_daily_rec, by="description") %>%
      #scale pct_daily_rec to match calories
      mutate("pct_daily_rec" = pct_daily_rec_per_100kcal*calories/100) %>%
      #calculate total pct_daily_rec accross all selected foods
      group_by(component_name) %>%
      summarise("pct_daily_rec_total" = sum(pct_daily_rec)) %>%
      #cap pct_daily_rec at 100%
      mutate(pct_daily_rec_total = case_when(pct_daily_rec_total > 100 ~100,
                                             TRUE ~pct_daily_rec_total))
    })
  
  output$pct_daily_rec <- renderPlot({
    pct_daily_rec_df() %>%
      ggplot(aes(x=component_name, y=pct_daily_rec_total)) +
      geom_col() +
      coord_flip()
  })
  
  #############################################################################################
  # FOOD GROUP TAB
  
  output$hist_nd_63 <- renderPlot({
    food_group_select <- switch(input$select_food_group,
                         "no food group" = "no food group",
                         "dairy" = "dairy",
                         "grains" = "grains",
                         "vegetables" = "vegetables",
                         "fruits" = "fruits",
                         "protein foods" ="protein foods")
    
    nutrient_density_score %>% 
      filter(food_group == food_group_select)%>%
      pivot_longer(c("nd_63", "nd_hybrid"),
                   names_to = "nd_type",
                   values_to = "nd_score") %>%
      ggplot(aes(x=nd_score, fill=nd_type)) + 
      geom_histogram(bins=100, position = "identity", alpha = 0.5)
  })
  
  #############################################################################################
  # ABOUT THE DATA TAB
  
  output$data_nds <- renderDataTable(nutrient_density_score)
  
  output$data_pdg <- renderDataTable(pct_daily_rec)
}


shinyApp(ui=ui, server=server)
