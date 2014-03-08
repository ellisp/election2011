# assumes existence of 'number_electorates' variable from import_candidate_vote.R


#--------- Download 70 csvs for candidate vote------------------

filenames <- paste0("raw_data/e9_part8_party_", 1:number_electorates, ".csv")

for (i in 1:number_electorates){
  download.file(paste0("http://www.electionresults.govt.nz/electionresults_2011/e9/csv/e9_part8_party_", i, ".csv"), 
                filenames[i], quiet=TRUE)
}

#---------------------Tidy-------------------
results_polling_place <- list()

for (i in 1:number_electorates){
  
  # What is the electorate name?  Is in cell A2 of each csv
  electorate <- read.csv(filenames[i], skip=1, nrows=1, header=FALSE, stringsAsFactors=FALSE)[,1]
  
  # read in the bulk of the data
  tmp <- read.csv(filenames[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE)
  
  first_blank <- which(tmp[,2] == "")[1]
  
  # we knock out all the rows from first_blank - 1 (which is the total)
  tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
  names(tmp)[1:2] <- c("Polling_Location", "Polling_Place")
  
  
  # need to fill in the gaps where there is no polling location
  last_polling_location <- tmp[1, 1]
  for(j in 1: nrow(tmp)){
    if(tmp[j, 1] == "") {
      tmp[j, 1] <- last_polling_location
    } else {
      last_polling_location <- tmp[j, 1]
    }
  }  
  
  tmp <- melt(tmp[, names(tmp) != "Total Valid Party Votes"], id.vars=c("Polling_Location", "Polling_Place"),
              variable.name="Party", value.name="Votes")
  
  tmp$Electorate <- electorate
  results_polling_place[[i]] <- tmp
}

party_results_polling_place <- do.call("rbind", results_polling_place)

save(party_results_polling_place, file="pkg/data/party_results_polling_place.rda")

rm(tmp)