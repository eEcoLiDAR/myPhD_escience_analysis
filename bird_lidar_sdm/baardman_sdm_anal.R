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
full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/"

birdfile="Baardman_indpres_kmsquareabs_joined.csv"
lidarfile="lidarmetrics_wetlands_expanded2.grd"

setwd(full_path)

#LiDAR
lidarmetrics=stack(lidarfile)
lidarmetrics <- dropLayer(lidarmetrics,c("density_absolute_mean_all","point_density","max_z_all","perc_10_all","perc_30_all","perc_50_all","perc_70_all","perc_90_all", "mean_z_all"))

v <- vifstep(lidarmetrics,th=10)
v
lidarmetrics2 <- exclude(lidarmetrics,v)

polygon_100mcell <- rasterToPolygons(lidarmetrics[[1]])
polygon_100mcell@data$lidarmetrics_100m_ID=seq(from=1,to=nrow(polygon_100mcell@data),by=1)

#Bird
bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

bird_data$x_observation=bird_data$X
bird_data$y_observation=bird_data$Y

bird_data_shp=bird_data[c("X","Y","x_observation","y_observation","species","occurrence")]
coordinates(bird_data_shp)=~x_observation+y_observation
proj4string(bird_data_shp)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

writeOGR(bird_data_shp,".","Baardman_bird_data", driver="ESRI Shapefile")

intersect_poly_birdobs = point.in.poly(bird_data_shp, polygon_100mcell)

bird_data_intersect=intersect_poly_birdobs@data

bird_data_presabs=bird_data_intersect[complete.cases(bird_data_intersect), ]

#Check Pres-Absence ratio

print(paste("Absence:",nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==0),]),sep=" "))
print(paste("Presence:",nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==1),]),sep=" "))

pres=bird_data_presabs[ which(bird_data_presabs$occurrence==1),]
abs=bird_data_presabs[ which(bird_data_presabs$occurrence==0),]

nofpres=nrow(bird_data_presabs[ which(bird_data_presabs$occurrence==1),])

abs_sampled=abs[sample(nrow(abs), nofpres), ]

presabs_bird <- rbind(pres, abs_sampled) 

bird_obs=presabs_bird[c("X","Y","occurrence")]
coordinates(bird_obs)=~X+Y
proj4string(bird_obs)<- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")

#Export SDM input
writeOGR(bird_obs,".","Baardman_bird_data_forSDM", driver="ESRI Shapefile")
writeRaster(lidarmetrics2,"lidarmetrics_forSDM.grd",overwrite=TRUE)

# SDM

data_forsdm <- sdmData(formula=occurrence~., train=bird_obs, predictors=lidarmetrics2)
data_forsdm

model1 <- sdm(occurrence~.,data=data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=2)
model1

# Response curve

rcurve(model1,id = 1)
rcurve(model1,id = 3)
rcurve(model1,id = 5,mean=F,confidence = T)
rcurve(model1,id = 7)
rcurve(model1,id = 9)
rcurve(model1,id = 11)
a <- getResponseCurve(model1,id=5)
roc(model1)
a@response


# Feature importance

feaimp_1=getVarImp(model1,id = 1)
plot(feaimp_1,'auc')
plot(feaimp_1,'cor')

feaimp_2=getVarImp(model1,id = 3)
plot(feaimp_2,'auc')
plot(feaimp_2,'cor')

feaimp_3=getVarImp(model1,id = 5)
plot(feaimp_3,'auc')
plot(feaimp_3,'cor')

feaimp_4=getVarImp(model1,id = 7)
plot(feaimp_4,'auc')
plot(feaimp_4,'cor')

feaimp_5=getVarImp(model1,id = 9)
plot(feaimp_5,'auc')
plot(feaimp_5,'cor')

feaimp_6=getVarImp(model1,id = 11)
plot(feaimp_6,'auc',cex.axis=0.6,cex=0.6)
plot(feaimp_6,'cor')
boxplot()
# Exploration orig. predictors
featureset=data_forsdm@features

presence=data_forsdm@species$occurrence@presence
absence=data_forsdm@species$occurrence@absence

featureset$occurrence <- 2

featureset$occurrence[1:172] <- 1
featureset$occurrence[173:306] <- 0

featureset$rID <- NULL

colNames <- names(featureset)[1:12]

for (name in colNames) {
  p <- ggplot(featureset, aes_string(x="occurrence",y=name)) + geom_boxplot(aes(group=factor(occurrence),fill=factor(occurrence)))
  
  ggsave(paste(name,'_baardman_boxplot.jpg',sep=''),p)
}

model1@data@features.name

niche(lidarmetrics2,model1@data,n=c("roughness.1" ,"perc_30_nonground"))
# Predict

p1 <- predict(model1,newdata=lidarmetrics2,filename='')
plot(p1)

writeRaster(p1,"Baardman_sdm_predict2.tif",overwrite=TRUE)

ens1 <- ensemble(model1, newdata=lidarmetrics2, filename="",setting=list(method='weighted',stat='AUC',opt=2))
writeRaster(ens1,"Baardman_ensemble_auc.tif",overwrite=TRUE)