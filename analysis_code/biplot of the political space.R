

byTA2 <- dcast(byTA, TA ~ Party, sum, value.var="Votes")
totals <- apply(byTA2[,-1], 2, sum)

WhoIsIn <- names(totals[order(-totals)])[1:8]

byTA.pc <- princomp(t(scale(t(byTA2[, WhoIsIn]))))
biplot(byTA.pc, xlabs=byTA2[,1], cex=.5)