# this is the makefile for preparing the test data for KNN
# this file reads ALL MACS

macs =    c("00:0f:a3:39:e1:c0", "00:0f:a3:39:dd:cd", "00:14:bf:b1:97:8a",
            "00:14:bf:3b:c7:c6", "00:14:bf:b1:97:90", "00:14:bf:b1:97:8d",
            "00:14:bf:b1:97:81")

online = readData("Data/online.final.trace.txt")
online$posXY = paste(online$posX, online$posY, sep = "-")

keepVars = c("posXY", "posX", "posY", "orientation", "angle")
byLoc = with(online, 
             by(online, list(posXY), 
                function(x) {
                  ans = x[1, keepVars]
                  avgSS = tapply(x$signal, x$mac, mean)
                  y = matrix(avgSS, nrow = 1, ncol = 7,
                             dimnames = list(ans$posXY, names(avgSS)))
                  cbind(ans, y)
                }))

onlineSummary = do.call("rbind", byLoc)  

# write.csv(onlineSummary, file="Data/onlineSummary.csv", row.names=FALSE)