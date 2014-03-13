library(shiny)

# Define UI 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Election Results 2011 and Census 2013"),
  
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
    
     selectInput("variable", "Census variable:",
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
    
    selectInput("SortBy", "Sort by:",
                choices=list("Party", 
                             "Census Variable" = "CensusVariable"),
                selected = "Party")
    
    ),
  
  # Show the 
  mainPanel(
    plotOutput("dots", height="800px")
  )
    
      
  
  )
)