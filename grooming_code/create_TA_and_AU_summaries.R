library(census2013)
library(mbiemaps)
data(TA)
data(AU)

#==============aggregate up by TA and by area unit===================

byArea <- merge(party_results_polling_place, Polling_Place_latlong@data, 
              by.x="Polling_Place", by.y="Address", all.x=TRUE) 


#--------------------TA-----------------------
# Aggregate vote by TA
byTA <- ddply(byArea, .(TA_fullname, TA, Party), summarise,
              Votes = sum(Votes))

# Change the NAs to 'Unknown or overseas'
byTA$TA_fullname <- as.character(byTA$TA_fullname)
byTA[is.na(byTA)] <- "Unknown or overseas"

# Calculate the total votes (including informal) for later use
TA_totals <- ddply(byTA, .(TA), summarise, Total_Votes = sum(Votes))

# Transform so you have the percentage vote within each TA
byTA <- ddply(byTA, .(TA_fullname, TA), mutate, 
              Percentage = Votes / sum(Votes))

# Cast into wide form - one column per Party
byTA <- dcast(byTA, TA_fullname + TA ~ Party, sum, value.var="Percentage")

# Add back in the total vote as an extra column
byTA <- merge(byTA, TA_totals, all=TRUE)

# Add the various information (area, length, centre coordinates) from the shapefile
byTA <- merge(byTA, TA@data, by.x="TA_fullname", by.y="NAME", all.x=TRUE)


# AU
byAU <- ddply(byArea, .(AU, Party), summarise,
              Votes = sum(Votes))
byAU$AU <- as.character(byAU$AU)
byAU[is.na(byAU)] <- "Unknown or overseas"

AU_totals <- ddply(byAU, .(AU), summarise, Total_Votes = sum(Votes))

byAU <- ddply(byAU, .(AU), mutate, 
              Percentage = Votes / sum(Votes))
byAU <- dcast(byAU, AU ~ Party, sum, value.var="Percentage")

byAU <- merge(byAU, AU_totals, all=TRUE)



byAU <- merge(byAU, AU@data, by.x="AU", by.y="NAME", all.x=TRUE)


#===================combine with a selection of census data==================


#----------------collate census data----------------------
# View(TableVariables)


# Comment - not clear why this data has 3.7m people as the Total people total ages in total new zealand
census1 <- ddply(subset(C01Pop_T1, Age=="Total"), .(Geography), summarise,
      Proportion_Maori_People = sum(Total_People[Ethnicity == "Maori"]) / Total_People[Ethnicity == "Total People"])


census2 <- subset(C01Income_T1, Ethnicity == "Total People" & Age_group =="Total")
census2 <- census2[ , c("Geography", "Median_Personal_Income_Dollars", "Mean_Personal_Income_Dollars")]

# warning - think this is the one with the mean and median transposed hence we swap them roung
census3 <- subset(Cincome_T4, Ethnicity == "Total People")
census3 <- census3[ , c("Geography", "Median_Household_Income_Dollars", "Mean_Household_Income_Dollars")]
names(census3) <- c("Geography", "Mean_Household_Income_Dollars", "Median_Household_Income_Dollars")

census4 <- subset(CWork_T3, Ethnicity == "Total People")
census4 <- census4[ , c("Geography", "Unemployment_Rate_Percent", "Unemployed")]
census4$Unemployment_Rate_Proportion <- census4$Unemployment_Rate_Percent / 100
census4$Unemployment_Rate_Percent <- NULL

census5 <- ddply(subset(CEducation_T1, Age_Group=="Total" & Ethnicity == "Total People"), .(Geography), summarise,
                 Proportion_No_Education = sum(Total_People[Level_of_education == "None"]) / 
                   Total_People[Level_of_education == "Total"],
                 Proportion_Higher_Education = sum(Total_People[Level_of_education == "Level 7/Bachelors and above"]) / 
                   Total_People[Level_of_education == "Total"])

census_combined <- merge(census1, census2, by="Geography")
census_combined <- merge(census_combined, census3, by="Geography")
census_combined <- merge(census_combined, census4, by="Geography")
census_combined <- merge(census_combined, census5, by="Geography")

rm(census1, census2, census3, census4, census5)

census_combined_ta <- subset(census_combined, substring(census_combined$Geography, 4, 4) == " ")
nc <- nchar(as.character(census_combined_ta$Geography))
census_combined_ta$TA_fullname <- substring(census_combined_ta$Geography, 5, nc)


# add back in Auckland
census_combined_ta <- rbind(census_combined_ta, 
                            data.frame(subset(census_combined, Geography == "02 Auckland Region"), TA_fullname = "Auckland"))

#-------------------------merge with TA information-----------------------
byTA <- merge(byTA, census_combined_ta, by = "TA_fullname", all.x=TRUE)

#===================save======================

party_vote_by_TA <- byTA
party_vote_by_AU <- byAU
save(party_vote_by_TA, file="pkg/data/party_vote_by_TA.rda")
save(party_vote_by_AU, file="pkg/data/party_vote_by_AU.rda")
