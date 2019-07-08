"
@author: Zsofia Koma, UvA
Aim: Pre-process presence-only data
"

library(rgdal)
library(raster)

source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper2_v2/1_bird_data_preprocess/Function_CreatePresAbs.R")

# Set working dirctory
workingdirectory="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/Dataprocess_Paper2_2/"
setwd(workingdirectory)

birdfile="avimap_observations_reedland_birds.csv" # using the one which contains more observation also outside of NL

ahn3="D:/Sync/_Amsterdam/03_Paper2_bird_lidar_sdm/DataProcess_Paper2_1/lidar/ahn3.shp"

#Import
birds=read.csv(birdfile,sep=";")

ahn3_poly = readOGR(dsn=ahn3)

# Select only one species
species=unique(birds$species)

GreedW=birds[birds$species=="Grote Karekiet" & birds_1$year>"2013",]

# Create shp
GreedW_shp=CreateShape(GreedW)

# Intersect with AHN3

# Intersection observation points with AHN3 extent
intersected_1=intersect(GreedW_shp,ahn3_poly)
intersected_1_df=intersected_1@data

# Create req AHN3 list 
ahn3list=Create_reqahn3(ahn3_poly,GreedW_shp)

write.table(ahn3list$list, file = "greatwarbler_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 