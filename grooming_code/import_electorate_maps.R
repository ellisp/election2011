library(sp)
library(rgdal)
library(mbiemaps) # for AddCoord


download.file("https://www3.stats.govt.nz/digitalboundaries/annual/New%20Zealand%202007%20Electoral%20Districts%20(NZTM)%20(8.35MB).zip",
              "raw_data/shapefiles/electoral_boundaries.zip")

path <- "raw_data/shapefiles/New Zealand 2007 Electoral Districts"

unzip("raw_data/shapefiles/electoral_boundaries.zip", exdir="raw_data/shapefiles")



electorates_map <- readOGR(dsn=path, layer="ged07")
electorates_map@data <- AddCoord(electorates_map)
tmp <- fortify(electorates_map, region="NAME")
names(tmp) <- gsub("id", "NAME", names(tmp))
tmp2 <- merge(tmp, electorates_map@data, suffixes=c("", ".centre"), by="NAME")
electorates_map_gg <- tmp2

save(electorates_map, file="pkg/data/electorates_map.rda")
save(electorates_map_gg, file="pkg/data/electorates_map_simpl_gg.rda")

rm(tmp, tmp2, path)

# ggplot(electorates_map_gg, aes(x=long, y=lat, group=group, fill=NAME)) + geom_polygon()