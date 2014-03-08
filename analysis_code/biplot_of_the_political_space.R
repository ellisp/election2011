
names(party_vote_by_TA)

totals <- apply(party_vote_by_TA[, 3:15], 2, sum)

WhoIsIn <- names(totals[order(-totals)])[1:8]

byTA.pc <- princomp(t(scale(t(party_vote_by_TA[, WhoIsIn]))))

png("output/biplot of political space.png", 6000, 6000, res=600)
  biplot(byTA.pc, xlabs=party_vote_by_TA[, "TA"], cex=.8)
dev.off()