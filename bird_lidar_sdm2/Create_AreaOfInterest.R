"
@author: Zsofia Koma, UvA
Aim: This script creates the 1 km ROIs
"
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
library("sf")

# Set working directory
workingdirectory="C:/Koma/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_2/" ## set this directory where you would like to put your las files
setwd(workingdirectory)

# Filenames 
ahn3file="listahn3.csv"
ahn3_polyfile="ahn3.shp"
kmsquare_file="kmsquare_aslist.csv"

birdfile="fulllist_wahn3.csv"

# Import  

ahn3list=read.csv(file=ahn3file,header=TRUE,sep=",")
ahn3_poly = readOGR(dsn=ahn3_polyfile)
kmsquares_poly.df=read.csv(file=kmsquare_file,header=TRUE,sep=",")

bird_data=read.csv(file=birdfile,header=TRUE,sep=",")

# Select required ahn3 polygons
bird_data_sel = bird_data %>% filter(bladnr %in% ahn3list$bladnr)

bird_data_sel_bykmsquare=ddply(bird_data_sel,~kmsquare+species+bladnr,summarise,sum=sum(occurrence))
bird_data_sel_bykmsquare = within(bird_data_sel_bykmsquare, {
  occurrence = ifelse(sum >0, 1, 0)
})

# Add kmsquare coords

bird_data_sel_bykmsquare_wcoord=merge(bird_data_sel_bykmsquare,kmsquares_poly.df,by="kmsquare",all.x = TRUE)
write.csv(bird_data_sel_bykmsquare_wcoord, file = 'bird_data_sel_bykmsquare_wcoord.csv',row.names=FALSE)
