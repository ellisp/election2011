library(devtools)
rm(list=ls())

#---------------vote data----------------
# import data from web
source("grooming_code/import_candidate_vote.R")
source("grooming_code/import_party_vote.R")

# tidy it
source("grooming_code/tidy_candidate_vote.R")
source("grooming_code/tidy_party_vote.R")

#--------------electorate data------------------
source("grooming_code/import_electorate_maps.R")
source("grooming_code/import_polling_place_coordinates.R")


#---------------combinations------------------

source("grooming_code/create_TA_and_AU_summaries.R")


#------------build package-----------------
build("pkg", path="C:/Users/Peter Ellis/Dropbox/Packages")
build("pkg", path="C:/Users/Peter Ellis/Dropbox/Packages", binary=TRUE)


#=========Analysis from here====================
rm(list=ls())
library(election2011)

source("analysis_code/biplot_of_the_political_space.R")
source("analysis_code/colour_polling_places_by_dominant_party.R")
source("analysis_code/multiple_choropleth_maps_by_TA.R")
source("analysis_code/multiple_choropleth_maps_by_AU.R")
source("analysis_code/Party_vote_by_electorate.R")
source("analysis_code/three_way_choropleth_map.R")


