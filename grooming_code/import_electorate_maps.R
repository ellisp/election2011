library(sp)
library(rgdal)


path <- "C:/users/peter ellis/documents/shapefiles/New Zealand 2007 Electoral Districts"


electorates_map <- readOGR(dsn=path, layer="ged07")
electorates_map_gg <- fortify(electorates_map, region="NAME")

save(electorates_map, file="pkg/data/electorates_map.rda")
save(electorates_map_gg, file="pkg/data/electorates_map_simpl_gg.rda")