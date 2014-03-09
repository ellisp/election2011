library(shiny)
library(election2011)




# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  
  
  output$dots <- renderPlot({
    tmp <- party_vote_by_TA[ , c("TA", input$party)]
    tmp <- tmp[order(tmp[, 2]), ]
    colour <- party_colours[input$party]
    dotchart(tmp[ , 2] * 100, labels=tmp$TA, col=colour, pch=19)
  })
  
  

  
})