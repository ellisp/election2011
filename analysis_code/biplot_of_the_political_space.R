
names(party_vote_by_TA)
byTA2 <- dcast(byTA, TA ~ Party, sum, value.var="Votes")
totals <- apply(party_vote_by_TA[, 3:15], 2, sum)

WhoIsIn <- names(totals[order(-totals)])[1:8]

byTA.pc <- princomp(t(scale(t(party_vote_by_TA[, WhoIsIn]))))
biplot(byTA.pc, xlabs=party_vote_by_TA[, "TA"], cex=.5)