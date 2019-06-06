library(lidR)
library(lidRplugins)
library(SDMTools)
library(landscapemetrics)

setwd("D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_preprocess/")

las = readLAS("humanlandscape.las", select = "xyzci")
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

writeLAS(las_plan,"eigenreclassified2.laz")

## Raster based

las_ngr_a20=lasfilter(las_ngr,Z > 20)

col  <- height.colors(50)
eigm <- grid_metrics(las_ngr_a20, .stdshapemetrics, 1)
plot(eigm, col = col)

#Trying out object based fetaures

lasnormalize(las,knnidw(k=20,p=2))

maxh=grid_metrics(las, max(Z), 10)
plot(maxh)

pulsepen=grid_metrics(las, (length(Z[Classification==2])/length(Z))*100, 10)
plot(pulsepen)

maxh_class=reclassify(maxh, c(-Inf,0.25,1, 0.25,2.5,2, 2.5,5,3, 5,20,4,20,Inf,5))

pal <- colorRampPalette(c("purple","blue","cyan","green","yellow","red"))
plot(maxh_class,col=pal(5))

plot(las)

maxh_class[pulsepen < 50] <- 4
plot(maxh_class,col=pal(5))

varint=grid_metrics(las, var(Intensity), 10)
plot(varint)

PatchStat(maxh_class, cellsize = 10, latlon = FALSE)

lsm_p_enn(maxh_class)
lsm_l_ta(maxh_class)
lsm_c_te(maxh_class)

ClassStat(maxh_class, cellsize = 10)

