"
@author: Zsofia Koma, UvA
Aim: SDM
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
library("usdm")

# Set global variables
full_path="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"
#full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess/"

birdfile="Baardman_bird_presabs_lidar.csv"
lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

#Import
lidarmetrics=stack(lidarfile)
lidarmetrics <- dropLayer(lidarmetrics,c("density_absolute_mean_all","point_density"))

bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

print(paste("Absence:",nrow(bird_data[ which(bird_data$occurrence==0),]),sep=" "))
print(paste("Presence:",nrow(bird_data[ which(bird_data$occurrence==1),]),sep=" "))

pres=bird_data[ which(bird_data$occurrence==1),]
abs=bird_data[ which(bird_data$occurrence==0),]

nofpres=nrow(bird_data[ which(bird_data$occurrence==1),])

abs_sampled=abs[sample(nrow(abs), nofpres), ]

presabs_bird <- rbind(pres, abs_sampled) 

bird_obs=presabs_bird[c("X","Y","occurrence")]
coordinates(bird_obs)=~X+Y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

# Intersection

presabsrast <- rasterize(bird_obs, lidarmetrics[[22]],field="occurrence")

masked <- mask(lidarmetrics, presabsrast)

# convert training data into the right format
trainingbrick <- addLayer(masked, presabsrast)
featuretable <- getValues(trainingbrick)
featuretable <- na.omit(featuretable)
featuretable <- as.data.frame(featuretable)

library(randomForest)
library(caret)

trainIndex <- caret::createDataPartition(y=featuretable$layer, p=0.75, list=FALSE)
trainingSet<- featuretable[trainIndex,]
testingSet<- featuretable[-trainIndex,]

modelFit <- randomForest(factor(layer)~.,data=trainingSet)

prediction <- predict(modelFit,testingSet[ ,c(1:25)])

conf_m=confusionMatrix(factor(prediction), factor(testingSet$layer),mode = "everything")

print(conf_m)

library(plotmo)

plotmo(modelFit, type="prob", nresponse="0",all1=TRUE,all2 = FALSE)
plotmo(modelFit, type="response",all1=TRUE,all2 = FALSE)

p <- ggplot(featuretable, aes(x=layer,y=max_z_all,group=factor(layer))) + 
  geom_boxplot()
p

colNames <- names(featuretable)[1:25]

for (name in colNames) {
  p <- ggplot(featuretable, aes_string(x="layer",y=name)) + geom_boxplot(aes(group=factor(layer)))
  
  ggsave(paste(name,'_baardman_boxplot.jpg',sep=''),p)
}