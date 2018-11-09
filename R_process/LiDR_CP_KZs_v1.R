"
@author: Zsofia Koma, UvA
Aim: Global ecology and biodiversity MSc course, LiDAR execise solutions
2018 November
"

# Import required libraries
library("lidR")
library("raster")
library("maptools")

library("e1071")

# Set global variables (workspace)
full_path="D:/Koma/MSc_course/"
filename="flavopark_forCP.las"

setwd(full_path)

par(mfrow=c(1,1)) # set 1 by 1 plot by default

######################## Execise 1. ########################
# Import data
las = readLAS(filename)

# Explore briefly
print(las@header@PHB$`Number of point records`)
print(las@header@PHB$`Min Z`)
print(las@header@PHB$`Max Z`)

hist(las@data$Z)

plot(las)

# Explore the Classification flag
print(unique(las@data$Classification))

ground = lasfilter(las, Classification == 2)
plot(ground)
vegetation = lasfilter(las, Classification == 1)
plot(vegetation)
building = lasfilter(las, Classification == 6)
plot(building)
water = lasfilter(las, Classification == 9)
plot(water)
other = lasfilter(las, Classification == 26)
plot(other)

plot(las,color="Classification",colorPalette=random.colors(26))

######################## Execise 2. ########################

# Create DTM and normlaize the point cloud
nonvegetation = lasfilter(las, Classification != 1)

dtm = grid_terrain(nonvegetation, res = 5, method = "knnidw", k = 25L)
plot(dtm)

lasnormalize(las, dtm)

hist(las@data$Z)

# Calculate maximum height
hmax = grid_metrics(las, max(Z), res=1)
plot(hmax)

# Exclude extra objects (bulding, water, bridges)
filteres_pc = lasfilter(las, Classification < 3)

hmax_filt = grid_metrics(filteres_pc, max(Z), res=1)
plot(hmax_filt)

# Locate highest trees
highest_trees=hmax_filt[which(hmax_filt$V1>25)]
plot(highest_trees)

######################## Execise 3. ########################

# Calculate LiDAR metrics at 1 m resolution
hmax_1m = grid_metrics(nonvegetation, max(Z), res=1)
plot(hmax_1m)

hmean_1m = grid_metrics(nonvegetation, mean(Z), res=1)
plot(hmean_1m)

hmedian_1m = grid_metrics(nonvegetation, median(Z), res=1)
plot(hmedian_1m)

hmin_1m = grid_metrics(nonvegetation, min(Z), res=1)
plot(hmin_1m)

hperc025_1m = grid_metrics(nonvegetation, quantile(Z, 0.25), res=1)
plot(hperc025_1m)

hperc075_1m = grid_metrics(nonvegetation, quantile(Z, 0.75), res=1)
plot(hperc075_1m)

hperc09_1m = grid_metrics(nonvegetation, quantile(Z, 0.90), res=1)
plot(hperc09_1m)

hstd_1m = grid_metrics(nonvegetation, sd(Z), res=1)
plot(hstd_1m)

hvar_1m = grid_metrics(nonvegetation, var(Z), res=1)
plot(hvar_1m)

hkurto_1m = grid_metrics(nonvegetation, kurtosis(Z), res=1)
plot(hkurto_1m)

hskew_1m = grid_metrics(nonvegetation, skewness(Z), res=1)
plot(hskew_1m)

hpulsepen_1m = grid_metrics(nonvegetation, length(Z[Classification==2])/length(Z), res=1)
plot(hpulsepen_1m)

# Calculate LiDAR metrics at 10 m resolution
hmax_10m = grid_metrics(nonvegetation, max(Z), res=10)
plot(hmax_10m)

hmean_10m = grid_metrics(nonvegetation, mean(Z), res=10)
plot(hmean_10m)

hmedian_10m = grid_metrics(nonvegetation, median(Z), res=10)
plot(hmedian_10m)

hmin_10m = grid_metrics(nonvegetation, min(Z), res=10)
plot(hmin_10m)

hperc025_10m = grid_metrics(nonvegetation, quantile(Z, 0.25), res=10)
plot(hperc025_10m)

hperc075_10m = grid_metrics(nonvegetation, quantile(Z, 0.75), res=10)
plot(hperc075_10m)

hperc09_10m = grid_metrics(nonvegetation, quantile(Z, 0.90), res=10)
plot(hperc09_10m)

hstd_10m = grid_metrics(nonvegetation, sd(Z), res=10)
plot(hstd_10m)

hvar_10m = grid_metrics(nonvegetation, var(Z), res=10)
plot(hvar_10m)

hkurto_10m = grid_metrics(nonvegetation, kurtosis(Z), res=10)
plot(hkurto_10m)

hskew_10m = grid_metrics(nonvegetation, skewness(Z), res=10)
plot(hskew_10m)

hpulsepen_10m = grid_metrics(nonvegetation, length(Z[Classification==2])/length(Z), res=10)
plot(hpulsepen_10m)

# Calculate LiDAR metrics at 100 m resolution
hmax_100m = grid_metrics(nonvegetation, max(Z), res=100)
plot(hmax_100m)

hmean_100m = grid_metrics(nonvegetation, mean(Z), res=100)
plot(hmean_100m)

hmedian_100m = grid_metrics(nonvegetation, median(Z), res=100)
plot(hmedian_100m)

hmin_100m = grid_metrics(nonvegetation, min(Z), res=100)
plot(hmin_100m)

hperc025_100m = grid_metrics(nonvegetation, quantile(Z, 0.25), res=100)
plot(hperc025_100m)

hperc075_100m = grid_metrics(nonvegetation, quantile(Z, 0.75), res=100)
plot(hperc075_100m)

hperc09_100m = grid_metrics(nonvegetation, quantile(Z, 0.90), res=100)
plot(hperc09_100m)

hstd_100m = grid_metrics(nonvegetation, sd(Z), res=100)
plot(hstd_100m)

hvar_100m = grid_metrics(nonvegetation, var(Z), res=100)
plot(hvar_100m)

hkurto_100m = grid_metrics(nonvegetation, kurtosis(Z), res=100)
plot(hkurto_100m)

hskew_100m = grid_metrics(nonvegetation, skewness(Z), res=100)
plot(hskew_10m)

hpulsepen_100m = grid_metrics(nonvegetation, length(Z[Classification==2])/length(Z), res=100)
plot(hpulsepen_100m)

# Plot one metrics and 3 different resolution in one plot
par(mfrow=c(1,3))
plot(hpulsepen_1m,main="Pulse penetration ratio 1 m")
plot(hpulsepen_10m,main="Pulse penetration ratio 10 m")
plot(hpulsepen_100m,main="Pulse penetration ratio 100 m")

# Export data as raster
hmax_100m_r <- rasterFromXYZ(hmax_100m[,c(1,2,3)])
hmean_100m_r <- rasterFromXYZ(hmean_100m[,c(1,2,3)])
hmedian_100m_r <- rasterFromXYZ(hmedian_100m[,c(1,2,3)])
hmin_100m_r <- rasterFromXYZ(hmin_100m[,c(1,2,3)])
hperc025_100m_r <- rasterFromXYZ(hperc025_100m[,c(1,2,3)])
hperc075_100m_r <- rasterFromXYZ(hperc075_100m[,c(1,2,3)])
hperc09_100m_r <- rasterFromXYZ(hperc09_100m[,c(1,2,3)])
hstd_100m_r <- rasterFromXYZ(hstd_100m[,c(1,2,3)])
hvar_100m_r <- rasterFromXYZ(hvar_100m[,c(1,2,3)])
hkurto_100m_r <- rasterFromXYZ(hkurto_100m[,c(1,2,3)])
hskew_100m_r <- rasterFromXYZ(hskew_100m[,c(1,2,3)])
hpulsepen_100m_r <- rasterFromXYZ(hpulsepen_100m[,c(1,2,3)])

# Stacking the raster layers together
lidarmetrics_raster= stack(hmax_100m_r, hmean_100m_r,hmedian_100m_r,hmin_100m_r,hperc025_100m_r,hperc075_100m_r,hperc09_100m_r,hstd_100m_r,hvar_100m_r,hkurto_100m_r,hskew_100m_r,hpulsepen_100m_r) 
plot(lidarmetrics_raster)

writeRaster(lidarmetrics_raster, paste(substr(filename, 1, nchar(filename)-4) ,"_metrics.tif",sep=""),overwrite=TRUE)
