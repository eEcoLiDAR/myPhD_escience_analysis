"
@author: Zsofia Koma, UvA
Aim: explore sdm modelling for Global Ecology and Biodiversity course
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")

library("sdm")
library("corrplot")
library("Hmisc")

# Set global variables
full_path="C:/Users/zsofi/Google Drive/_Amsterdam/xOther/lidar_bird_dsm_workflow/birdatlas/"
birdfile="Breeding_bird_atlas_aggregated_data_kmsquaresKleine Karekiet_grouped_presabs_lidar.rds"
lidarfile="terrainData100m_run1_filtered_lidarmetrics_lidar_whoutoulier.tif"

setwd(full_path)

# Import LiDAR and bird observations
birdand_lidar=readRDS(file = birdfile)
lidarmetrics=stack(lidarfile)

# Explore variables
# Analyse bird-lidar
corr_m <- rcorr(as.matrix(birdand_lidar[,7:20]))

corrplot(corr_m$r, type="upper", order="hclust", 
         p.mat = corr_m$P, sig.level = 0.01, insig = "blank")

hclust_avg <- hclust(dist(birdand_lidar[,7:20], method = 'euclidean'), method = 'average')
plot(hclust_avg)

cut_avg <- cutree(hclust_avg, k = 2)
birdand_lidar_clust <- mutate(birdand_lidar, cluster = cut_avg)

filteredbird_lidarmetrics_r=rasterFromXYZ(birdand_lidar_clust[,c(2,3,21)])
writeRaster(filteredbird_lidarmetrics_r, paste(substr(birdfile, 1, nchar(birdfile)-4) ,"_clustered.tif",sep=""),overwrite=TRUE)

#Cluster lidar
lidarmetrics_pc = rasterToPoints(lidarmetrics)
lidarmetrics_df = data.frame(lidarmetrics_pc)

hclust_avg <- hclust(dist(lidarmetrics_df[50000:60000,c(3,5,13)], method = 'euclidean'), method = 'average')
plot(hclust_avg)

cut_avg <- cutree(hclust_avg, k = 2)
lidarmetrics_clust <- mutate(lidarmetrics_df[50000:60000,c(1,2)], cluster = cut_avg)

lidarmetrics_r=rasterFromXYZ(lidarmetrics_clust[,c(1,2,3)])
writeRaster(lidarmetrics_r, paste(substr(lidarfile, 1, nchar(lidarfile)-4) ,"_clustered.tif",sep=""),overwrite=TRUE)


# Correlation


# Data prep. for SDM

bird_obs=birdand_lidar[c("x","y","presence")]
coordinates(bird_obs)=~x+y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=presence~., train=bird_obs, predictors=lidarmetrics)
data_forsdm

# Modelling
model1 <- sdm(presence~.,data=data_forsdm,methods=c('glm','brt','rf'))
model1

roc(model1)

# Predict
p1 <- predict(model1,newdata=lidarmetrics,filename='p3m.img')
plot(p1)

#GUI
gui(model1)
