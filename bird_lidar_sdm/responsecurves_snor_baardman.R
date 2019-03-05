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
full_path="D:/Koma/Paper3/DataProcess/"
#full_path="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_3/"

snorfile="Snor_bird_data_forSDM.shp"
baardmanfile="Baardman_bird_data_forSDM.shp"

lidarfile="lidarmetrics_forSDM.grd"

setwd(full_path)

# Import
lidarmetrics=stack(lidarfile)

Snor=readOGR(dsn=snorfile)
Baardman=readOGR(dsn=baardmanfile)

# Intersection

snor_data_forsdm <- sdmData(formula=occurrence~., train=Snor, predictors=lidarmetrics)
snor_data_forsdm

baardman_data_forsdm <- sdmData(formula=occurrence~., train=Baardman, predictors=lidarmetrics)
baardman_data_forsdm

# Modelling

snor_model <- sdm(occurrence~.,data=snor_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=50)
snor_model

save(snor_model,file = "snor_model.RData")

baardman_model <- sdm(occurrence~.,data=baardman_data_forsdm,methods=c('glm','gam','brt','rf','svm','mars'),replication=c('boot'),n=50)
baardman_model

save(baardman_model,file = "baardman_model.RData")

# Response curves

rcurve(snor_model,id = 1)
rcurve(snor_model,id = 3)
rcurve(snor_model,id = 5)
rcurve(snor_model,id = 7)
rcurve(snor_model,id = 9)
rcurve(snor_model,id = 11)

rcurve(baardman_model,id = 1)
rcurve(baardman_model,id = 3)
rcurve(baardman_model,id = 5)
rcurve(baardman_model,id = 7)
rcurve(baardman_model,id = 9)
rcurve(baardman_model,id = 11)

# make nice graph

response_snor_svm=getResponseCurve(snor_model,id = 201)
response_baardman_svm=getResponseCurve(baardman_model,id = 201)

# pulsepen

response_snor_svm@response$pulse_pen_ratio_all$species <- "Savi's Warbler"
response_baardman_svm@response$pulse_pen_ratio_all$species <- "Bearded Reedling"

pulse_pen=rbind(response_snor_svm@response$pulse_pen_ratio_all,response_baardman_svm@response$pulse_pen_ratio_all)

# rough

response_snor_svm@response$roughness.1$species <- "Savi's Warbler"
response_baardman_svm@response$roughness.1$species <- "Bearded Reedling"

roughness=rbind(response_snor_svm@response$roughness.1,response_baardman_svm@response$roughness.1)

# var

response_snor_svm@response$var_z_all$species <- "Savi's Warbler"
response_baardman_svm@response$var_z_all$species <- "Bearded Reedling"

var_z_all=rbind(response_snor_svm@response$var_z_all,response_baardman_svm@response$var_z_all)

# max

response_snor_svm@response$max_z__nonground$species <- "Savi's Warbler"
response_baardman_svm@response$max_z__nonground$species <- "Bearded Reedling"

max_z__nonground=rbind(response_snor_svm@response$max_z__nonground,response_baardman_svm@response$max_z__nonground)

# plot

p1=ggplot(data=pulse_pen, aes(x=pulse_pen_ratio_all, y=`svm_ID-201`,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  xlab("Pulse penetration ratio [%]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.25, 1)

p2=ggplot(data=roughness, aes(x=roughness.1, y=`svm_ID-201`,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  xlab("Surface roughness [m]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.25, 1)

p3=ggplot(data=max_z__nonground, aes(x=max_z__nonground, y=`svm_ID-201`,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  xlab("Vegetation height [m]") + ylab("Response") + theme_bw(base_size = 30) + ylim(0.25, 1)

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)
