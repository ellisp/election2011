library(devtools)

# import data from web
source("grooming_code/import_candidate_vote.R")
source("grooming_code/import_party_vote.R")

# tidy it
source("grooming_code/tidy_candidate_vote.R")
source("grooming_code/tidy_party_vote.R")


build("pkg", path="C:/Users/Peter Ellis/Dropbox/Packages")
build("pkg", path="C:/Users/Peter Ellis/Dropbox/Packages", binary=TRUE)

