library(shiny)
library(election2011)


# 
input <- data.frame(variable="Mean_Household_Income_Dollars", party="Green Party")

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  
  output$scatter <- renderPlot({
    
    
    tmp <- party_vote_by_TA[ , c("TA", as.character(input$variable1), as.character(input$party), as.character(input$variable2))]
    names(tmp) <- c("TA", "x", "y", "size")
    colour <- party_colours[input$party]
    if(length(grep("roportion", input$variable1)) >0 ){
      Yscale <- scale_x_continuous(gsub("_", " ", input$variable1, fixed=TRUE), label=percent)
    } else {
      Yscale <- scale_x_continuous(gsub("_", " ", input$variable1, fixed=TRUE), label=comma)
    }
    
    if(length(grep("roportion", input$variable2)) >0 ){
      Sscale <- scale_size(wrap(gsub("_", " ", input$variable2, fixed=TRUE), 12), label=percent)
    } else {
      Sscale <- scale_size(wrap(gsub("_", " ", input$variable2, fixed=TRUE), 12), label=comma)
    }
    
    
      p <- ggplot(tmp, aes(x=x, y=y, size=size, label=TA)) +
              geom_text(colour=colour) +
              scale_y_continuous(paste0("Vote for ", input$party, "\n"), label=percent) +
              Yscale +
              Sscale
      if(input$regression){
        p <- p + geom_smooth(method="lm")
      }
    print(p)
  })
  
  

  
})