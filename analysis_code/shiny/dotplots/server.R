library(shiny)
library(election2011)



# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # input <- data.frame(party="Green Party", variable="Mean_Household_Income_Dollars", SortBy = "Party")
  
  output$dots <- renderPlot({
    p <- as.character(input$party)
    v <- as.character(input$variable)
    tmp <- party_vote_by_TA[ , c("TA", p, v)]
    names(tmp) <- c("TA", "Party", "CensusVariable")
    tmp[ , -1] <- scale(tmp[ , -1])
    tmp_m <- melt(tmp, id.vars="TA")
    
    tmp_m$TA <- factor(tmp_m$TA, levels=tmp$TA[order(tmp[, as.character(input$SortBy)])])
    colours <- c(party_colours[input$party], "CensusVariable" = "purple")
    names(colours)[1] <- "Party"
    
    print(ggplot(tmp_m, aes(y=TA, x=value, color=variable, shape=variable)) +
            geom_point() +
            scale_color_manual("", values=colours, labels=c(p, v)) +
            scale_shape_discrete("", labels = c(p, v)) +
            scale_x_continuous("", labels=c("Below average", "Average", "Above average"), 
                                        breaks = c(-2, 0, 2)) +
            labs(y=""))
  })
  
  

  
})