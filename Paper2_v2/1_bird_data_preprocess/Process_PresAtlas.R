"
@author: Zsofia Koma, UvA
Aim: Pre-process atlas individual observation data
"

library(rgdal)
library(raster)

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

birdfile="Breeding_bird_atlas_individual_observations.csv" # using the individual observation data

ahn3="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"

#Import
birds=read.csv(birdfile,sep=";")

ahn3_poly = readOGR(dsn=ahn3)

# Select only one species
species=unique(birds$species)

names(birds)[14]<-"x"
names(birds)[15]<-"y"
names(birds)[17]<-"occurrence"

GreedW=birds[birds$species=="Grote Karekiet" & birds$year>"2013",]
ReedW=birds[birds$species=="Kleine Karekiet" & birds$year>"2013",]
BReed=birds[birds$species=="Baardman" & birds$year>"2013",]
SaviW=birds[birds$species=="Snor" & birds$year>"2013",]
SedgW=birds[birds$species=="Rietzanger" & birds$year>"2013",]

# Create shp
GreedW_shp=CreateShape(GreedW)
raster::shapefile(GreedW_shp, "GreedW_atl.shp",overwrite=TRUE)

ReedW_shp=CreateShape(ReedW)
raster::shapefile(ReedW_shp, "ReedW_atl.shp",overwrite=TRUE)

BReed_shp=CreateShape(BReed)
raster::shapefile(BReed_shp, "BReed_atl.shp",overwrite=TRUE)

SaviW_shp=CreateShape(SaviW)
raster::shapefile(SaviW_shp, "SaviW_atl.shp",overwrite=TRUE)

SedgW_shp=CreateShape(SedgW)
raster::shapefile(SedgW_shp, "SedgW_atl.shp",overwrite=TRUE)

# Intersect with AHN3 - create req AHN3 list 

GreedW_ahn3list=Create_reqahn3(ahn3_poly,GreedW_shp)
write.table(GreedW_ahn3list$list, file = "GreedW_ahn3list_atl.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

ReedW_ahn3list=Create_reqahn3(ahn3_poly,ReedW_shp)
write.table(ReedW_ahn3list$list, file = "ReedW_ahn3list_atl.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

BReed_ahn3list=Create_reqahn3(ahn3_poly,BReed_shp)
write.table(BReed_ahn3list$list, file = "BReed_ahn3list_atl.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

SaviW_ahn3list=Create_reqahn3(ahn3_poly,SaviW_shp)
write.table(SaviW_ahn3list$list, file = "SaviW_ahn3list_atl.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

SedgW_ahn3list=Create_reqahn3(ahn3_poly,SedgW_shp)
write.table(SedgW_ahn3list$list, file = "SedgW_ahn3list_atl.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 