
#---------------------Tidy-------------------
results_polling_place <- list()

for (i in 1:number_electorates){
  
  # What is the electorate name?  Is in cell A2 of each csv
  electorate <- read.csv(filenames_cand[i], skip=1, nrows=1, header=FALSE, stringsAsFactors=FALSE)[,1]
  
  # read in the bulk of the data
  tmp <- read.csv(filenames_cand[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE)
  
  first_blank <- which(tmp[,2] == "")
  candidates_parties <- tmp[(first_blank + 2) : nrow(tmp), 1:2]
  names(candidates_parties) <- c("Candidate", "Party")
  candidates_parties <- rbind(candidates_parties,
                              data.frame(Candidate="Informal Candidate Votes", Party="Informal Candidate Votes"))
  
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
  
  tmp <- melt(tmp[, names(tmp) != "Total Valid Candidate Votes"], id.vars=c("Polling_Location", "Polling_Place"),
              variable.name="Candidate", value.name="Votes")
  
  tmp$Electorate <- electorate
  tmp <- merge(tmp, candidates_parties, all.x=TRUE)
  results_polling_place[[i]] <- tmp
}

candidate_results_polling_place <- do.call("rbind", results_polling_place)
candidate_results_polling_place$Votes <- as.numeric(candidate_results_polling_place$Votes)

save(candidate_results_polling_place, file="pkg/data/candidate_results_polling_place.rda")

rm(candidates_parties, tmp)