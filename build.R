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

