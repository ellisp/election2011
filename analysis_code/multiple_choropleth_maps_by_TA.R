library(mbiemaps)


byTA <- merge(party_results_polling_place, Polling_Place_latlong@data, by.x="Polling_Place", by.y="Address", all.x=FALSE) # drops votes before polling day
byTA <- party_vote_by_TA[ , c("TA", "Green Party", "Labour Party", "National Party", "New Zealand First Party")]
  
  
names(byTA)[names(byTA) == "TA"] <- "NAME"



#===============
parties <- names(byTA)[-1]
byTA_m <- melt(byTA, id.vars="NAME", variable.name="Party", value.name="Percentage")


for(i in  1:length(parties)){
  byTA_m$NAME <- factor(byTA_m$NAME, levels=with(subset(byTA_m, Party==parties[i]), NAME[order(Percentage)]))
  
  png(paste0("output/barchart by TA ", parties[i], ".png"), 5000, 5000, res=500)
    print(
      ggplot(byTA_m, aes(x=NAME, y=Percentage, color=Party)) +
        geom_point(size=4) +
        scale_color_manual(values=party_colours) +
        scale_y_continuous(label=percent) +
        coord_flip() +
        labs(x="", title=paste0("Percentage vote in each TA, ordered by ", parties[i]))
    )
  dev.off()
}
#======================


# this doesn't work for some annoying reason, but probably isn't a winner anyway
data(ta_simpl_gg)
ta2_gg <- merge(ta_simpl_gg, byTA_m, all=TRUE, by="NAME", sort=FALSE)



p <- list()

for (i in 1:length(parties)){
  p[[i]] <-    ggplot(subset(ta2_gg, Party==parties[i])) +
    geom_polygon(aes(x=long, y=lat, group=group, fill = Percentage)) +
    mbie::theme_nothing() +
    coord_map() +
    scale_fill_gradient(low="white", high=party_colours[parties[i]], na.value="white", label=percent) +
    ggtitle(parties[i])
}

png("output/four choropleth maps by TA.png", 8000, 8000, res=600)
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  print(p[[1]], vp = vplayout(1,1))
  print(p[[2]], vp = vplayout(1,2))
  print(p[[3]], vp = vplayout(2,1))
  print(p[[4]], vp = vplayout(2,2))
dev.off()


