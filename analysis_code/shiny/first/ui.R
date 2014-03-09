library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Election Results 2011"),
  
  sidebarPanel(
    selectInput("party", "Order by party:",
                list("National Party", 
                     "Labour Party", 
                     "Green Party",
                     "New Zealand First Party",
                     "Maori Party",
                     "Mana",
                     "Aotearoa Legalise Cannabis Party"))
    
    
    
    ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    plotOutput("dots", height="800px")
  )
    
      
  
  )
)