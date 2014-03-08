library(election2011)
library(plyr)
library(directlabels)

#--------------party by electorate--------------------
party <- ddply(party_results_polling_place, .(Party, Electorate), summarise,
               Votes = sum(Votes))

party_cand <- ddply(candidate_results_polling_place, .(Party, Electorate), summarise,
               Votes = sum(Votes))

comb <- merge(party, party_cand, by=c("Party", "Electorate"), 
              suffixes=c("_partyvote", "_candidatevote"))

png("output/party vote by candidate vote by party and electorate.png", 7000, 5000, res=500)
  ggplot(comb, aes(x=Votes_partyvote, y=Votes_candidatevote, color=Party)) +
    geom_abline(xintercept=0, slope=1, colour="white") +
    geom_point() +
    scale_x_continuous(label=comma) +
    scale_y_continuous(label=comma) +
    coord_equal() +
    facet_wrap(~Party, scales="free")
dev.off()

#--------------------party overall vote---------------

legit_party <- sum(subset(party_results_polling_place, Party != "Informal Party Votes")$Votes)
legit_cand <- sum(subset(candidate_results_polling_place, Party != "Informal Candidate Votes")$Votes)

party_total <- ddply(subset(party_results_polling_place, Party != "Informal Party Votes"),
                     .(Party), summarise, 
                     Votes = sum(Votes),
                     Percentage = sum(Votes) / legit_party)

cand_total <- ddply(subset(candidate_results_polling_place, 
                           Party != "Informal Candidate Votes"), .(Party), summarise, 
                    Votes = sum(Votes),
                    Percentage = sum(Votes) / legit_cand)

comb_total <- merge(party_total, cand_total, by="Party", all=FALSE, 
                    suffixes=c("_partyvote", "_candidatevote"))

comb_total_m <- melt(comb_total[, c("Party", "Votes_partyvote", "Votes_candidatevote")], 
                     id.vars="Party", value.name="Votes")

comb_total_m$Party <- factor(comb_total_m$Party, 
                             levels=comb_total$Party[order(-comb_total$Votes_partyvote)])

png("output/party vote and candidate vote barcharts.png", 7000, 5000, res=500)
ggplot(comb_total_m, aes(x=Party, weight=Votes)) +
  geom_bar() +
  coord_flip() +
  facet_wrap(~variable, ncol=2) +
  scale_y_continuous("\nNumber of votes", label=comma) +
  labs(x="")
dev.off()


comb_total_m_p <- melt(comb_total[, c("Party", "Percentage_partyvote", "Percentage_candidatevote")], 
                     id.vars="Party", value.name="Percentage")

comb_total_m_p$Party <- factor(comb_total_m_p$Party, 
                             levels=comb_total$Party[order(-comb_total$Votes_partyvote)])

png("output/party vote and candidate percentage barcharts.png", 7000, 5000, res=500)
ggplot(comb_total_m_p, aes(x=Party, weight=Percentage)) +
  geom_bar() +
  coord_flip() +
  facet_wrap(~variable, ncol=2) +
  scale_y_continuous("\nNumber of votes", label=percent) +
  labs(x="")
dev.off()

png("output/party vote and candidate percentage scatterplot.png", 7000, 7000, res=500)
direct.label(
  ggplot(comb_total, aes(x=Percentage_candidatevote, y=Percentage_partyvote)) +
    geom_abline(xintercept=0, slope=1, colour="white") +
    geom_point(aes(color=Party)) +
    scale_x_log10(label=percent) +
    scale_y_log10(label=percent) +
    coord_equal()
)
dev.off()