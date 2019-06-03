library(lidR)
library(lidRplugins)

setwd("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/")

las = readLAS("humanlandscape.las", select = "xyzc")
col = c("gray", "gray", "blue", "darkgreen", "darkgreen", "darkgreen", "red", "gray", "cyan", "darkgray", "gray", "pink", "pink", "purple", "pink")

## Point Cloud based

# filter for non ground points
las_ngr=lasfilter(las,Classification != 2L)

# Perform approximate colinear test on non ground point
las_plan = lascoplanar(las_ngr, k = 10, th1 = 5, th2 = 0)

# Reclassify colinear points as wire if not already classified as building
las_plan@data[Colinear == TRUE & Classification != 6L, Classification := 14L]

# plot
plot(las_plan, color = Classification, colorPalette = col[3:15])

writeLAS(las_plan,"eigenreclassified.laz")

## Raster based

las_ngr_a20=lasfilter(las_ngr,Z > 20)

col  <- height.colors(50)
eigm <- grid_metrics(las_ngr_a20, .stdshapemetrics, 1)
plot(eigm, col = col)

maxh=grid_metrics(las_ngr, max(Z), 1)
plot(maxh)