# assumes existence of 'number_electorates' variable from import_candidate_vote.R


#--------- Download 70 csvs for candidate vote------------------

filenames_part <- paste0("raw_data/e9_part8_party_", 1:number_electorates, ".csv")

for (i in 1:number_electorates){
  download.file(paste0("http://www.electionresults.govt.nz/electionresults_2011/e9/csv/e9_part8_party_", i, ".csv"), 
                filenames_part[i], quiet=TRUE)
}
