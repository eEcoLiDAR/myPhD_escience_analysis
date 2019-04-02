"
@author: Zsofia Koma, UvA
Aim: Classify the data
"
library(raster)
library(rgdal)
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")

# Set working dirctory
workingdirectory="D:/Koma/Paper1_v2/Run3_2019April/"
setwd(workingdirectory)

#Skipped: selection of training data from polygon + buffer and recategorization

# Input

classes1 = rgdal::readOGR("selpolyper_level1_v5.shp")
classes2 = rgdal::readOGR("selpolyper_level2_v5.shp")
classes3 = rgdal::readOGR("selpolyper_level3_v5.shp")

lidarmetrics_forl1=stack("lidarmetrics_l1_masked.grd")
lidarmetrics_forl23=stack("lidarmetrics_l2l3_masked_wgr.grd")

featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

### Level1 ###

# Classification
level1="level1"
Pred_l1=Classification_werrorass(featuretable_l1,lidarmetrics_forl1,level1)
writeRaster(Pred_l1, filename="classified_level1.tif", format="GTiff",overwrite=TRUE)

# Mask 
formask <- setValues(raster(lidarmetrics_forl23), NA)
formask[Pred_l1==2] <- 1

lidarmetrics_masked1 <- mask(lidarmetrics_forl23,formask)
#writeRaster(lidarmetrics_masked1, filename="lidarmetrics_forlevel2.grd",overwrite=TRUE)

### Level2 ###

# Classification
level2="level2"
Pred_l2=Classification_werrorass(featuretable_l2,lidarmetrics_masked1,level2)
writeRaster(Pred_l2, filename="classified_level2.tif", format="GTiff",overwrite=TRUE)

# Mask 
formask2 <- setValues(raster(lidarmetrics_forl23), NA)
#formask2[Pred_l2==4 | Pred_l2==5] <- 1
formask2[Pred_l2==3] <- 1

lidarmetrics_masked2 <- mask(lidarmetrics_masked1,formask2)
#writeRaster(lidarmetrics_masked2, filename="lidarmetrics_forlevel3.grd",overwrite=TRUE)

### Level3 ###

# Classification
level3="level3"
Pred_l3=Classification_werrorass(featuretable_l3,lidarmetrics_masked2,level3)
writeRaster(Pred_l3, filename="classified_level3.tif", format="GTiff",overwrite=TRUE)