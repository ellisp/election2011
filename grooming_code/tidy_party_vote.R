
#---------------------Tidy-------------------
results_polling_place <- list()

for (i in 1:number_electorates){
  
  # What is the electorate name?  Is in cell A2 of each csv
  electorate <- read.csv(filenames_part[i], skip=1, nrows=1, header=FALSE, stringsAsFactors=FALSE)[,1]
  
  # read in the bulk of the data
  tmp <- read.csv(filenames_part[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE)
  
  first_blank <- which(tmp[,2] == "")[1]
  
  # we knock out all the rows from first_blank - 1 (which is the total)
  tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
  names(tmp)[1:2] <- c("Polling_Location", "Polling_Place")
  
  # in some of the data there are annoying subheadings in the second column.  We can
  # identify these as rows that return NA when you sum up where the votes should be
  tmp <- tmp[!is.na(apply(tmp[, -(1:2)], 1, function(x){sum(as.numeric(x))})), ]
  
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
party_results_polling_place$Votes <- as.numeric(party_results_polling_place$Votes)

party_results_polling_place$Party <- rename.levels(party_results_polling_place$Party, orig="MÄori Party", new= "Maori Party")

save(party_results_polling_place, file="pkg/data/party_results_polling_place.rda")

rm(tmp)