
byTA <- merge(party_results_polling_place, Polling_Place_latlong@data, 
              by.x="Polling_Place", by.y="Address", all.x=FALSE) # drops votes before polling day

byTA <- dcast(byTA, TA ~ Party, sum, value.var="Votes")
totals <- apply(byTA[,-1], 2, sum)

WhoIsIn <- names(totals[order(-totals)])[1:8]

byTA.pc <- princomp(t(scale(t(byTA[, WhoIsIn]))))
biplot(byTA.pc, xlabs=byTA[,1], cex=.5)