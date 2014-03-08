library(mbiemaps)

byAU <- merge(party_results_polling_place, Polling_Place_latlong@data, by.x="Polling_Place", by.y="Address", all.x=FALSE) # drops votes before polling day
byAU <- ddply(byAU, .(AU), summarise,
              "Green Party" = sum(Votes[Party == "Green Party"]) / sum(Votes),
              "Labour Party" = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              "National Party" = sum(Votes[Party == "National Party"]) / sum(Votes),
              "New Zealand First Party" = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes))

names(byAU)[names(byAU) == "AU"] <- "NAME"


#===============

byAU_m <- melt(byAU, id.vars="NAME", variable.name="Party", value.name="Percentage")

data(au_simpl_gg)

au2_gg <- join(au_simpl_gg, byAU_m, type="full", by="NAME")


parties <- names(byAU)[-1]

p <- list()

for (i in 1:length(parties)){
  p[[i]] <-    ggplot(subset(au2_gg, Party==parties[i])) +
                  geom_polygon(aes(x=long, y=lat, group=group, fill = Percentage)) +
                  theme_nothing(legend=TRUE) +
                  coord_map() +
                  scale_fill_gradient(low="white", high=party_colours[parties[i]], na.value="white", label=percent) +
                  ggtitle(parties[i])
}

png("output/four choropleth maps.png", 8000, 8000, res=600)
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  print(p[[1]], vp = vplayout(1,1))
  print(p[[2]], vp = vplayout(1,2))
  print(p[[3]], vp = vplayout(2,1))
  print(p[[4]], vp = vplayout(2,2))
dev.off()
