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

ahn3_actimefile="ahn3_measuretime.shp"

#Import
birds=read.csv(birdfile,sep=";")

ahn3_poly = readOGR(dsn=ahn3)
ahn3_actime = readOGR(dsn=ahn3_actimefile)

# Select only one species
species=unique(birds$species)

birds$occurrence<-1

GreedW=birds[birds$species=="Grote Karekiet" & birds$year>"2013",]
ReedW=birds[birds$species=="Kleine Karekiet" & birds$year>"2013",]
BReed=birds[birds$species=="Baardman" & birds$year>"2013",]
SaviW=birds[birds$species=="Snor" & birds$year>"2013",]

# Create shp
GreedW_shp=CreateShape(GreedW)
raster::shapefile(GreedW_shp, "GreedW_avi.shp",overwrite=TRUE)

ReedW_shp=CreateShape(ReedW)
raster::shapefile(ReedW_shp, "ReedW_avi.shp",overwrite=TRUE)

BReed_shp=CreateShape(BReed)
raster::shapefile(BReed_shp, "BReed_avi.shp",overwrite=TRUE)

SaviW_shp=CreateShape(SaviW)
raster::shapefile(SaviW_shp, "SaviW_avi.shp",overwrite=TRUE)

# Intersect with AHN3 - create req AHN3 list 

GreedW_ahn3list=Create_reqahn3(ahn3_poly,GreedW_shp)
write.table(GreedW_ahn3list$list, file = "GreedW_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

ReedW_ahn3list=Create_reqahn3(ahn3_poly,ReedW_shp)
write.table(ReedW_ahn3list$list, file = "ReedW_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

BReed_ahn3list=Create_reqahn3(ahn3_poly,BReed_shp)
write.table(BReed_ahn3list$list, file = "BReed_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

SaviW_ahn3list=Create_reqahn3(ahn3_poly,SaviW_shp)
write.table(SaviW_ahn3list$list, file = "SaviW_ahn3list.txt", append = FALSE, quote = FALSE, sep = "", 
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, 
            col.names = FALSE, qmethod = c("escape", "double")) 

# Intersect with year of acquision

GreedW_ahn3ac=raster::intersect(GreedW_shp,ahn3_actime)
GreedW_ahn3ac_df=GreedW_ahn3ac@data

GreedW_ahn3ac_df$acq_sync <- GreedW_ahn3ac_df$year == GreedW_ahn3ac_df$Jaar

GreedW_withac_shp=CreateShape(GreedW_ahn3ac_df)
raster::shapefile(GreedW_withac_shp, "GreedW_avi_wacq.shp",overwrite=TRUE)

ReedW_ahn3ac=raster::intersect(ReedW_shp,ahn3_actime)
ReedW_ahn3ac_df=ReedW_ahn3ac@data

ReedW_ahn3ac_df$acq_sync <- ReedW_ahn3ac_df$year == ReedW_ahn3ac_df$Jaar

ReedW_withac_shp=CreateShape(ReedW_ahn3ac_df)
raster::shapefile(ReedW_withac_shp, "ReedW_avi_wacq.shp",overwrite=TRUE)

BReed_ahn3ac=raster::intersect(BReed_shp,ahn3_actime)
BReed_ahn3ac_df=BReed_ahn3ac@data

BReed_ahn3ac_df$acq_sync <- BReed_ahn3ac_df$year == BReed_ahn3ac_df$Jaar

BReed_withac_shp=CreateShape(BReed_ahn3ac_df)
raster::shapefile(BReed_withac_shp, "BReed_avi_wacq.shp",overwrite=TRUE)

SaviW_ahn3ac=raster::intersect(SaviW_shp,ahn3_actime)
SaviW_ahn3ac_df=SaviW_ahn3ac@data

SaviW_ahn3ac_df$acq_sync <- SaviW_ahn3ac_df$year == SaviW_ahn3ac_df$Jaar

SaviW_withac_shp=CreateShape(SaviW_ahn3ac_df)
raster::shapefile(SaviW_withac_shp, "SaviW_avi_wacq.shp",overwrite=TRUE)

# Stat. report about nof presence

counts_wfilters <- data.frame("time acq filter" = c(length(GreedW_ahn3ac_df$acq_sync[GreedW_ahn3ac_df$acq_sync==TRUE]),
                                                    length(ReedW_ahn3ac_df$acq_sync[ReedW_ahn3ac_df$acq_sync==TRUE]),
                                                    length(SaviW_ahn3ac_df$acq_sync[SaviW_ahn3ac_df$acq_sync==TRUE]),
                                                    length(BReed_ahn3ac_df$acq_sync[BReed_ahn3ac_df$acq_sync==TRUE])))
