library(shiny)
library(rhandsontable)
library(shinythemes)
library(dplyr)
library(tidyr)
library(ggplot2)
# 
# setwd("C:/Users/Owner/repos/nutrition_dashboard/data/")
# 
# nutrient_density_score <- read.csv("nutrient_density_score.csv", stringsAsFactors = FALSE)
# pct_daily_rec <- read.csv("percent_daily_recommendation.csv",stringsAsFactors = TRUE)

nutrient_density_score <- read.csv("https://raw.githubusercontent.com/sjaraha/nutrient-density-scores-shiny-app/main/nutrient_density_score.csv", stringsAsFactors = FALSE)
pct_daily_rec <- read.csv("https://raw.githubusercontent.com/sjaraha/nutrient-density-scores-shiny-app/main/percent_daily_recommendation.csv", stringsAsFactors = FALSE)

initial_food_selection <- "milk"

style <- theme(plot.title = element_text(face = "bold", size = 15),
               plot.subtitle = element_text(face = "plain", size = 13),
               axis.title = element_text(size = 13, face="italic"),
               axis.text = element_text(size = 13),
               legend.text = element_text(size = 13),
               legend.title = element_text(face = "bold", size = 13),
               legend.position = "right",
               panel.background = element_rect(fill = NA),
               panel.grid.major = element_line(colour = "grey88"),
               axis.ticks = element_line(color=NA),
               axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
               axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)))

ui <- fluidPage(
  
  theme = shinytheme("united"),
  
  navbarPage(
    "Nutrient Density Scores",
    id = "main",
    
    tabPanel(
      "By Food",
      
      br(),
      
      h4("Do you ever wonder whether your daily diet is giving you enough nutrients?"),
      p("Nutrient density is the nutrient content of foods expressed per 100 kcal. Nutrient density scores offer a way to rank foods based on their nutrient content. Many methods for calculating nutrient density have been proposed, and the calculation method continues to be researched and developed. This tool calculates nutrient density using the most current method: the hybrid nutrient density score."),
    
      h4("Hybrid Nutrient Density Score"),
      p("The hybrid nutrient density score is based on six",
      tags$em("nutrients to encourage"), 
      " (protein, dietary fiber, vitamin D, potassium, calcium, iron), three",
      tags$em("nutrients to limit"),
      " (sodium, saturated fat, total sugars), and five ",
      tags$em("food groups to encourage"), 
      " (whole grains, fruits, vegetables, dairy, nuts & seeds). Scores range from -100 to 350. The higher the score, the more encouraged nutrients or food groups exist per 100 kcal of a particular food. For more on how the hybrid nutrient density score is calculated, please see ", 
        a(href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6489166/", "this research paper.")),
  
      h4("How to use the tool"),
      p("First, search and select foods using the \"Food\" dropdown menu. Next, specify the number of calories consumed. Add your selection to the table to see the  nutrient density score for each food. The resulting chart will show the percentage of the recommended daily intake of each component of the hybrid nutrient density score fulfilled by the total selection."),
      
      br(),
      
      fluidRow(
          #input: dropdown menu to select foods
          column(width = 4,
               selectInput(inputId = "select_food",
                           label = "Food:",
                           choices = nutrient_density_score$description,
                           selected = initial_food_selection)),
          column(width = 2,
                 numericInput(inputId = "calories",
                              label = "Calories (kcal):",
                              value = 100,
                              step = 50)),
      ),
      
      fluidRow(
        column(width = 2,
               actionButton(inputId = "add_food",
                            label = "add food")),
        column(width = 2,
               actionButton(inputId = "remove_food",
                            label = "remove food")),
        column(width = 2,
               actionButton(inputId = "clear_all",
                            label = "clear all"))
      ),
      
      br(),
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
      "By Food Group",
      
      br(),
      
      h4("The calculation of nutrient density is a developing field of research."),
      p("Prior to the hybrid nutrient density score, nutrient density was calculated using the nutrient rich foods index. The nutrient rich foods index balances nutrients to encourage against nutrients to limit, without considering food groups to encourage. Many iterations of the nutrient rich foods index have been proposed, using anywhere from six to fifteen nutrients to encourage against three nutrients to limit (saturated fats, sugars, sodium)."),
      br(),
      p("The histogram below shows the distribution of nutrient density scores when using the nutrient rich foods index and the hybrid nutrient density score. Six nutrients to encourage were considered when calculating the nutrient rich foods index (protein, dietary fiber, vitamin D, potassium, calcium, iron)."),
      
      br(),
      
      fluidRow(
        #input: food group radio boxes
        column(width = 4,
               radioButtons(inputId = "select_food_group",
                            label = "Select a food group:",
                            choices = unique(nutrient_density_score$food_group))
               ),
        #output: histogram
        column(width = 8,
               plotOutput(outputId = "histogram")
               ),
      ),
    ),
    
    tabPanel(
      "About the Data",
      
      br(),
      
      h3("Sources"),
      
      br(),
      
      p("Data from the",
      a(" Food and Nutrition Database for Dietary Studies (FNDDS)", href = "https://www.ars.usda.gov/northeast-area/beltsville-md-bhnrc/beltsville-human-nutrition-research-center/food-surveys-research-group/docs/fndds/"),
      " and the",
      a(" Food Pattern Equivalent Database (FPED)", href = "https://www.ars.usda.gov/northeast-area/beltsville-md-bhnrc/beltsville-human-nutrition-research-center/food-surveys-research-group/docs/fped-overview/"),
      " were combined to create the tables used in this application. Data for daily recommendations and nutrient score calculations were sourced from",
      a(" this research paper",href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6489166/"),
      " The resulting tables are shown below."),
      br(),
      p(tags$b("FNDDS"), 
        " contains",
        tags$em(" nutrient data"), 
        " for foods reported in What We Eat in America (WWEIA), a national food survey conducted by the U.S. Department of Agriculture (USDA) and the Department of Health and Human Services (DHHS).",
        tags$b(" FPED"), 
        " contains",
        tags$em("food group data"),
        " for foods in WWEIA."),
      
      br(),
      
      h3("Nutrient Density Score Table"),
      
      br(),
      
      fluidRow(
        #output: nutrient density score data table
        column(width = 12,
               dataTableOutput(outputId = "data_nds"))
      ),
      
      br(),
      
      h3("Percent of Daily Recommendation Table"),
      
      br(),
      
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
  
  # when "add food" button is pressed, bind selection to food_cal_values
  observeEvent(input$add_food,
               #get current value of food_cal_values
                {food_cal_current <- food_cal_values$data
                #alter food_cal_values
                food_cal_new <- bind_rows(food_cal_current,
                                            data.frame("description" = input$select_food,
                                                       "calories" = input$calories))
                #update food_cal_values with new values
                food_cal_values$data <- food_cal_new})
  
  # when "remove food" button is pressed, remove selection from food_cal_values
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
  
  # when "clear all" is selected, clear all foods
  observeEvent(input$clear_all,
          {food_cal_values$data <- food_cal_values$data[0,]})
  
  # filter data from nutrient_density_score
  nutrient_density_df <- reactive({food_cal_values$data %>% 
      left_join(nutrient_density_score, by="description") %>%
      rename("food" = description,
             "hybrid nutrient density score" = nd_hybrid) %>%
      select(-c(fdc_id, food_group, nd_63))})
  
  output$food_selection <- renderDataTable({nutrient_density_df()}, 
                                           options = list(searching = FALSE,
                                                          paging = FALSE))
  
  pct_daily_rec_df <- reactive({food_cal_values$data %>%
      #filter for selected foods
      left_join(pct_daily_rec, by="description") %>%
      #scale pct_daily_rec to match calories
      mutate("pct_daily_rec" = pct_daily_rec_per_100kcal*calories/100) %>%
      #calculate total pct_daily_rec across all selected foods
      group_by(component_name, component_type) %>%
      summarise("pct_daily_rec_total" = sum(pct_daily_rec)) %>%
      #cap pct_daily_rec at 100%
      mutate(pct_daily_rec_total = case_when(pct_daily_rec_total > 100 ~100,
                                             TRUE ~pct_daily_rec_total))
    })
  
  cols_food <- c("nutrient to limit" = "orange3",
             "nutrient to encourage" = "olivedrab4",
             "food group" = "olivedrab3")
  
  output$pct_daily_rec <- renderPlot({
    pct_daily_rec_df() %>%
      mutate(component_name = factor(component_name, levels = c("total sugars", "saturated fat", "sodium", "vitamin d", "iron", "calcium", "potassium", "dietary fiber", "protein", "dairy", "nuts and seeds", "whole grains", "vegetables", "fruits"))) %>%
      ggplot(aes(x=component_name, y=pct_daily_rec_total, fill=component_type)) +
      geom_col() +
      coord_flip() + 
      labs(title = "Percentage of Daily\nRecommendation Fulfilled",
           subtitle = "for components of the hybrid nutrient density score",
           y = "% daily recommendation fulfilled",
           x = "") + 
      scale_y_continuous(limits = c(0, 100), labels = scales::label_percent(scale=1)) +
      scale_fill_manual(values = cols_food,
                        aesthetics = c("color", "fill"),
                        name = "component type",
                        labels = c("food group to encourage", "nutrient to encourage", "nutrient to limit")) +
      style
  })
  
  #############################################################################################
  # FOOD GROUP TAB
  
  output$histogram <- renderPlot({
    food_group_select <- switch(input$select_food_group,
                         "no food group" = "no food group",
                         "dairy" = "dairy",
                         "grains" = "grains",
                         "vegetables" = "vegetables",
                         "fruits" = "fruits",
                         "protein foods" ="protein foods")
    
    cols_food_group <- c("nd_63" = "red4",
                         "nd_hybrid" = "purple")
    
    nutrient_density_score %>% 
      filter(food_group == food_group_select)%>%
      pivot_longer(c("nd_63", "nd_hybrid"),
                   names_to = "nd_type",
                   values_to = "nd_score") %>%
      ggplot(aes(x=nd_score, fill=nd_type)) + 
      geom_histogram(bins=100, position = "identity", alpha = 0.5) +
      labs(title = "Distribution of Nutrient Density Scores",
           x = "nutrient density score",
           y= "frequency") +
      scale_x_continuous(limits = c(-100,350)) +
      scale_y_continuous(limits = c(0,250)) +
      scale_fill_manual(values = cols_food_group,
                        aesthetics = c("fill", "color"),
                        name = "score",
                        labels = c("nutrient rich", "hybrid")) +
      style
  })
  
  #############################################################################################
  # ABOUT THE DATA TAB
  
  output$data_nds <- renderDataTable(nutrient_density_score,
                                     options = list(lengthMenu = c(5,10,20),
                                                    pageLength = 5))
  
  output$data_pdg <- renderDataTable(pct_daily_rec,
                                     options = list(lengthMenu = c(5,10,20),
                                                    pageLength = 5)                                     )
}


shinyApp(ui=ui, server=server)
