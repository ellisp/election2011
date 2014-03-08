library(proj4)
library(mbiemaps)
data(TA)
data(AU)

download.file("http://www.electionresults.govt.nz/electionresults_2011/2011_Polling_Place_Co-ordinates.csv", 
              "raw_data/2011_Polling_Place_Co-ordinates.csv")
Polling_Place_coords <- read.csv("raw_data/2011_Polling_Place_Co-ordinates.csv", stringsAsFactors=FALSE)


Polling_Place_coords <- subset(Polling_Place_coords, !is.na(NZTM2000.Easting))

names(Polling_Place_coords) <- gsub("NZTM2000.", "", names(Polling_Place_coords), fixed=TRUE)
names(Polling_Place_coords) <- gsub("Polling.Place.", "", names(Polling_Place_coords), fixed=TRUE)
Polling_Place_coords$Electorate.Name <- NULL

p4s <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"
tmp <- proj4::project(with(Polling_Place_coords, cbind(Easting, Northing)), 
                      proj=p4s,
                      inv = TRUE)

Polling_Place_latlong <- SpatialPointsDataFrame(coords =  tmp, 
                                                proj4string = TA@proj4string, 
                                                data = Polling_Place_coords[, c("Suburb", "Address")])


Polling_Place_latlong@data$TA_fullname <- over(Polling_Place_latlong, TA)$NAME
Polling_Place_latlong@data$AU <- over(Polling_Place_latlong, AU)$NAME

Polling_Place_latlong@data$AU[Polling_Place_latlong@data$Suburb == "Great Barrier Island"] <- "Great Barrier Island"
Polling_Place_latlong@data$TA_fullname[Polling_Place_latlong@data$Suburb == "Great Barrier Island"] <- "Auckland"

Polling_Place_latlong@data$TA <- gsub(" District", "", Polling_Place_latlong@data$TA_fullname)
Polling_Place_latlong@data$TA <- gsub(" City", "", Polling_Place_latlong@data$TA)


save(Polling_Place_coords, file="pkg/data/Polling_Place_coords.rda")
save(Polling_Place_latlong, file="pkg/data/Polling_Place_latlong.rda")

