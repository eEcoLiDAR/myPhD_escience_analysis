library("lidR")
library("raster")

las = readLAS("D:/Sync/_Amsterdam/Writing/MScThesis/tristan/Tristan_paper/g32hz1rect2.las")

hmean = grid_metrics(las, max(Z),res=1)
plot(hmean)

# ground classification
lasground(las, "pmf", 1, 0.5)
dtm = grid_terrain(las, method = "knnidw", k = 10L)
plot3d(dtm)

# normalization
lasnormalize(las, method = "knnidw", k = 10L)
plot(las)

chm = grid_canopy(las, res = 1, subcircle = 2, na.fill = "knnidw", k = 1)
chm = as.raster(chm)
plot(chm)

crowns = lastrees(las, "watershed", chm, th = 0.2, extra = TRUE)
contour = rasterToPolygons(crowns, dissolve = TRUE)

plot(hmean)
plot(contour, add = T,lwd=4)

ttops = tree_detection(hmean, 1, 2)
lastrees_dalponte(las, hmean, ttops)
plot(las, color = "treeID")
