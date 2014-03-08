library(mbiemaps)

byAU <- merge(party_results_polling_place, Polling_Place_latlong@data, by.x="Polling_Place", by.y="Address", all.x=FALSE) # drops votes before polling day
        
byAU <- ddply(byAU, .(AU), summarise,
              Green = sum(Votes[Party == "Green Party"]) / sum(Votes),
              Labour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              National = sum(Votes[Party == "National Party"]) / sum(Votes))

byAU$RGB <- with(byAU, rgb(red=Labour, green=Green, blue=National))

data(AU)

names(byAU)[names(byAU) == "AU"] <- "NAME"

# use join instead of merge to avoid the NA issue
newdata <- join(AU@data, byAU, by = "NAME", type = "left")
newdata$RGB[is.na(newdata$RGB)] <- "grey"

# check order ok
tail(data.frame(AU@data$NAME, newdata$NAME))

AU@data <- byAU

png("output/map by au.png", 5000, 6000, res=600)
  plot(AU, col=AU@data$RGB)
dev.off()