library(election2011)
library(ggthemes)
head(party_vote_by_TA)

png("output/TA_and_census/overall scatterplot education v Mana.png", 5000, 5000, res=500)
print(
  ggplot(party_vote_by_TA, aes(x=Proportion_Higher_Education, y=Mana)) +
  	# geom_point() +
  	geom_text(aes(label=TA)) +
  	scale_y_log10(label=percent) +
  	scale_x_log10(label=percent)
  )
dev.off()
	
# create an object with the names of all the parties
Parties <- names(party_vote_by_TA)[3:15]

# create a melted version of this data frame, keeping as id variable everything *except* the party names
party_vote_by_TA_m <- melt(party_vote_by_TA, 
	id.vars=names(party_vote_by_TA)[!names(party_vote_by_TA) %in% Parties],
	variable.name="Party",
	value.name="Proportion_Votes")


# in the plot below I drop the Liberatianz so we have 12 parties - better look
png("output/TA_and_census/by party scatterplot education v all parties.png", 8000, 5000, res=500)
print(
  ggplot(subset(party_vote_by_TA_m, Party != "Libertarianz"),
		aes(x = Proportion_Higher_Education, y = Proportion_Votes, label = TA)) +
	facet_wrap(~Party, scales="free", ncol=4) +
	geom_text(size=2) +
	geom_smooth(method="lm") +
	scale_y_continuous(label=percent) +
	scale_x_log10("\nProportion of population with L7 Bachelor or higher education (logarithmic scale)", label=percent, breaks = c(0.05, 0.1, 0.20, 0.40)) +
	theme_bw() +
  ggtitle("Party vote in the 2011 election\n")
  )
dev.off()