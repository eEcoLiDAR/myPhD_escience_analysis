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

setwd(full_path)

load("snor_model.RData")
load("baardman_model.RData")

# Get response curves

# Pulse Pen

pulsepen_snor=rcurve(snor_model,n=c("pulse_pen_ratio_all"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)
pulsepen_baardman=rcurve(baardman_model,n=c("pulse_pen_ratio_all"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)

pulsepen_snor[["data"]]$species="Savi's Warbler"
pulsepen_baardman[["data"]]$species="Bearded Reedling"

pulse_pen=rbind(pulsepen_snor[["data"]],pulsepen_baardman[["data"]])

pulse_pen$variable <- NULL

# Roughness

rough_snor=rcurve(snor_model,n=c("roughness.1"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)
rough_baardman=rcurve(baardman_model,n=c("roughness.1"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)

rough_snor[["data"]]$species="Savi's Warbler"
rough_baardman[["data"]]$species="Bearded Reedling"

roughness=rbind(rough_snor[["data"]],rough_baardman[["data"]])

roughness$variable <- NULL

# Max

max_z__nonground_snor=rcurve(snor_model,n=c("max_z__nonground"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)
max_z__nonground_baardman=rcurve(baardman_model,n=c("max_z__nonground"),id= c(seq(from=201,to=225,by=1)),mean=T,confidence=T)

max_z__nonground_snor[["data"]]$species="Savi's Warbler"
max_z__nonground_baardman[["data"]]$species="Bearded Reedling"

max_z__nonground=rbind(max_z__nonground_snor[["data"]],max_z__nonground_baardman[["data"]])

max_z__nonground$variable <- NULL

# Plot

p1=ggplot(data=pulse_pen, aes(x=Value, y=Response,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  geom_ribbon(aes(x=Value,ymin=lower, ymax=upper), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Proxy for vegetation coverage [%]") + ylab("Predicted probability") + theme_bw(base_size = 30) + scale_y_continuous(breaks=seq(0, 1.1, 0.2), limits=c(0.1, 1.1))

p2=ggplot(data=roughness, aes(x=Value, y=Response,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  geom_ribbon(aes(x=Value,ymin=lower, ymax=upper), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Canopy roughness [m]") + ylab("Predicted probability") + theme_bw(base_size = 30) + scale_y_continuous(breaks=seq(0, 1.1, 0.2), limits=c(0.1, 1.1))

p3=ggplot(data=max_z__nonground, aes(x=Value, y=Response,group=species,color=species)) + 
  scale_color_manual(values = c("Savi's Warbler"="tan2","Bearded Reedling"="chocolate4")) + 
  geom_line(size=3,show.legend = FALSE) + 
  geom_ribbon(aes(x=Value,ymin=lower, ymax=upper), linetype=2, alpha=0.1,show.legend = FALSE) +
  xlab("Vegetation height [m]") + ylab("Predicted probability") + theme_bw(base_size = 30) + scale_y_continuous(breaks=seq(0, 1.1, 0.2), limits=c(0.1, 1.1))

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)
