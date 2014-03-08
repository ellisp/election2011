library(proj4)

Polling_Place_coords <- read.csv("raw_data/2011_Polling_Place_Co-ordinates.csv", stringsAsFactors=FALSE)

names(Polling_Place_coords) <- gsub("NZTM2000.", "", names(Polling_Place_coords), fixed=TRUE)
names(Polling_Place_coords) <- gsub("Polling.Place.", "", names(Polling_Place_coords), fixed=TRUE)
names(Polling_Place_coords)[names(Polling_Place_coords)=="Electorate.Name"] <- "Electorate"


tmp <- proj4::project(with(Polling_Place_coords, cbind(Easting, Northing)), 
                      proj="+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m",
                      inv = TRUE)
Polling_Place_latlong <- data.frame(Polling_Place_coords[, c("Electorate", "Suburb", "Address")],
                                    lat=tmp[, 2], long=tmp[,1])




save(Polling_Place_coords, file="pkg/data/Polling_Place_coords.rda")
save(Polling_Place_latlong, file="pkg/data/Polling_Place_latlong.rda")

