library(RgoogleMaps)
library(ggmap)

elects <- unique(party_results_polling_place$Electorate)

for (i in 64: length(elects)){
  elect <- elects[i]
  
  poll <- subset(party_results_polling_place,  Electorate == elect &
                   Polling_Place != "Polling places where less than 6 votes were taken" &
                   Party != "Informal Party Votes")
  
  dominant <- ddply(poll, .(Polling_Place), summarise,
                    Biggest=Party[Votes==max(Votes)])
  
  vol <- ddply(poll, .(Polling_Place), summarise,
                    Volume = sum(Votes))
  dominant <- merge(dominant, vol)
  
  tmp <- merge(dominant, Polling_Place_latlong[ , c("Address", "lat", "long")], 
               by.x="Polling_Place", by.y="Address", all.x=FALSE)
  tmp <- subset(tmp, !is.na(lat))
  
  # To centre the map so all the coordinates included:
  # this_area <- get_map(location=c(long=mean(range(tmp$long)), lat=mean(range(tmp$lat))), zoom=9)
  
  # to centre it on the mass of the data:
  this_area <- get_map(location=c(long=mean(tmp$long), lat=mean(tmp$lat)), zoom=11, maptype = 'terrain')
  
  
  png(paste0("output/maps1/map of dominant party by polling place ", elect, ".png"), 6000, 4000, res=500)
  print(ggmap(this_area) +
    geom_point(data=tmp, aes(x=long, y=lat, color=Biggest, size=Volume), alpha=0.3) +
    geom_point(data=tmp, aes(x=long, y=lat, color=Biggest, size=Volume), pch=1) +
    scale_color_manual(values=party_colours) +
    ggtitle(paste0("Dominant party by polling location for ", elect, " in 2011 election")) +
    labs(size="Total valid\nparty votes"))
  dev.off()
      
}