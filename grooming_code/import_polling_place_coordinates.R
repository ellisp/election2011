

Polling_Place_coords <- read.csv("raw_data/2011_Polling_Place_Co-ordinates.csv", stringsAsFactors=FALSE)

names(Polling_Place_coords) <- gsub("NZTM2000.", "", names(Polling_Place_coords), fixed=TRUE)
names(Polling_Place_coords) <- gsub("Polling.Place.", "", names(Polling_Place_coords), fixed=TRUE)
names(Polling_Place_coords)[names(Polling_Place_coords)=="Electorate.Name"] <- "Electorate"
  
save(Polling_Place_coords, file="pkg/data/Polling_Place_coords.rda")
