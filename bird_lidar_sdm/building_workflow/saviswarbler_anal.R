"
@author: Zsofia Koma, UvA
Aim: explore the intersection of bird and lidar data 
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("gridExtra")

library("ggplot2")
library("sdm")

# Set global variables
#full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

filename="Snor_kmsquare_presabs_nl.csv"
lidarfile="Lidarmetrics_forMScCourse.grd"
landcoverfile="LGN7.tif"

setwd(full_path)

# Import LiDAR metrics
lidarmetrics=stack(lidarfile)
bird_data=read.csv(file=filename,header=TRUE,sep=",")
landcover=stack(landcoverfile)

# Habitat selection
formask <- setValues(raster(landcover), NA)
formask[landcover==30 | landcover==45 | landcover==41 | landcover==42] <- 1

formask=crop(formask,extent(lidarmetrics))
formask_resampled=resample(formask,lidarmetrics)

lidarmetrics_sel <- mask(lidarmetrics, formask_resampled)
#writeRaster(lidarmetrics_sel, "lidarmetrics_sel.grd",overwrite=TRUE)

gc()

# Intersection

bird_data$km_x=bird_data$X
bird_data$km_y=bird_data$Y

coordinates(bird_data)=~X+Y
proj4string(bird_data)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

vals <- raster::extract(lidarmetrics_sel,bird_data)
bird_data$pulsepen <- vals[,13]
bird_data$maxh <- vals[,17]
bird_data$std <- vals[,24]


bird_withLiDAR=bird_data@data
bird_withLiDAR=bird_withLiDAR[complete.cases(bird_withLiDAR), ]

write.csv(bird_withLiDAR, file = "Snor_bird_withLiDAR.csv",row.names=FALSE)

# Exploration analysis
#bird_withLiDAR=bird_withLiDAR[-sample(which(bird_withLiDAR$occurrence==0), 499),]

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=pulsepen,group=factor(occurrence))) + 
  geom_boxplot()
p

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=maxh,group=factor(occurrence))) + 
  geom_boxplot()
p

p <- ggplot(bird_withLiDAR, aes(x=occurrence,y=std,group=factor(occurrence))) + 
  geom_boxplot()
p

# SDM
bird_obs=bird_withLiDAR[c("km_x","km_y","occurrence")]
coordinates(bird_obs)=~km_x+km_y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

data_forsdm <- sdmData(formula=occurrence~., train=bird_obs, predictors=lidarmetrics_sel)
data_forsdm

model1 <- sdm(occurrence~.,data=data_forsdm,methods=c('glm','rf'),replication=c('boot'),n=2)
model1

roc(model1)
rcurve(model1,id = 3)

feaimp_rf=getVarImp(model1,id = 3)

feaimp_rf_ord <- feaimp_rf@varImportance[ order(feaimp_rf@varImportance[,3]), ]

response_glm=getResponseCurve(model1,id = 1)
response_rf=getResponseCurve(model1,id = 3)

ggplot(data=response_rf@response$perc_10_nonground, aes(x=perc_10_nonground, y=`rf_ID-3`)) +
  geom_line()+
  geom_point()

ggplot(data=response_glm@response$perc_90_nonground, aes(x=perc_90_nonground, y=`glm_ID-1`)) +
  geom_line()+
  geom_point()

#gui(model1)

p1 <- predict(model1,newdata=lidarmetrics_sel,filename='model1.tif')
plot(p1)

writeRaster(p1,"Snor_sdm_predict.tif",overwrite=TRUE)
writeRaster(p1[[3]],"Snor_sdm_predict_rf.tif",overwrite=TRUE)