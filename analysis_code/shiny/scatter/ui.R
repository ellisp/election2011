library(shiny)

# Define UI 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Election Results 2011 compared to Census 2013, by Territorial Authority"),
  
  sidebarPanel(
   
    selectInput("party", "Party:",
                choices=list("National Party", 
                             "Labour Party", 
                             "Green Party",
                             "New Zealand First Party",
                             "Maori Party",
                             "Mana",
                             "Aotearoa Legalise Cannabis Party"),
                selected = "National Party"),
    
    
    selectInput("variable1", "Census variable for horizontal axis:",
                choices=list("Mean household income" = "Mean_Household_Income_Dollars",
                             "Median household income" = "Median_Household_Income_Dollars",
                             "Mean personal income" = "Mean_Personal_Income_Dollars",
                             "Median personal income" = "Median_Personal_Income_Dollars",
                             "Percentage Maori" = "Proportion_Maori_People",
                             "Percentage highly educated" = "Proportion_Higher_Education",
                             "Percentage no education" = "Proportion_Higher_Education",
                             "Percentage unemployed" = "Unemployment_Rate_Proportion",
                             "Total voters" = "Total_Votes",
                             "Area of district" = "SHAPE_Area"),
                selected="Mean household income"), 
    
    selectInput("variable2", "Census variable for size of text:",
                choices=list("Mean household income" = "Mean_Household_Income_Dollars",
                             "Median household income" = "Median_Household_Income_Dollars",
                             "Mean personal income" = "Mean_Personal_Income_Dollars",
                             "Median personal income" = "Median_Personal_Income_Dollars",
                             "Percentage Maori" = "Proportion_Maori_People",
                             "Percentage highly educated" = "Proportion_Higher_Education",
                             "Percentage no education" = "Proportion_Higher_Education",
                             "Percentage unemployed" = "Unemployment_Rate_Proportion",
                             "Total voters" = "Total_Votes",
                             "Area of district" = "SHAPE_Area"),
                selected="Mean household income"),
    
    checkboxInput("regression", "Show regression line", FALSE)
    
    
    
    ),
  
  
  mainPanel(
    plotOutput("scatter", height="600px")
    )
    
      
  
  )
)