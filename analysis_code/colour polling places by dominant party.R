library(RgoogleMaps)
library(ggmap)

elects <- unique(party_results_polling_place$Electorate)


latlong_df <- data.frame(Polling_Place_latlong@data$Address, Polling_Place_latlong@coords)
names(latlong_df) <- c("Address", "long", "lat")


poll <- subset(party_results_polling_place,  
               Polling_Place != "Polling places where less than 6 votes were taken" &
               Party != "Informal Party Votes")

dominant <- ddply(poll, .(Polling_Place, Electorate), summarise,
                  Biggest=Party[Votes==max(Votes)])
vol <- ddply(poll, .(Polling_Place), summarise,
             Volume = sum(Votes))
dominant <- merge(dominant, vol)
dominant <- merge(dominant, latlong_df, 
                  by.x="Polling_Place", by.y="Address", all.x=FALSE)

table(dominant$Biggest)

for (i in 1: length(elects)){
  elect <- elects[i]
  
  # just the electorate:
  tmp <- subset(dominant, Electorate == elect)
  
  # to centre it on the centre of the electorate:
  this_area <- get_map(location=c(long=mean(tmp$long), lat=mean(tmp$lat)), zoom=11, maptype = 'terrain')
  
  
  png(paste0("output/maps1/map of dominant party by polling place centred in ", elect, ".png"), 6000, 4000, res=500)
  print(ggmap(this_area) +
    geom_point(data=dominant, aes(x=long, y=lat, color=Biggest, size=Volume), alpha=0.3) +
    geom_point(data=dominant, aes(x=long, y=lat, color=Biggest, size=Volume), pch=1) +
    scale_color_manual(values=party_colours) +
    ggtitle(paste0("Dominant party by polling location centred in ", elect, " in 2011 election")) +
    labs(size="Total valid\nparty votes"))
  dev.off()
      
}