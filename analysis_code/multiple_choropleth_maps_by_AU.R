library(mbiemaps)

byAU <- party_vote_by_AU[ , c("AU", "Green Party", "Labour Party", "National Party", "New Zealand First Party")]
  
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
                  mbie::theme_nothing() +
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
