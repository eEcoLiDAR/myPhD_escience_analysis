"
@author: Zsofia Koma, UvA
Aim: Classify the data
"
library(raster)
library(rgdal)
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")

# Set working dirctory
workingdirectory="D:/Koma/Paper1_v2/Run1_2019March/Classification/"
setwd(workingdirectory)

#Skipped: selection of training data from polygon + buffer and recategorization

# Input

classes1 = rgdal::readOGR("selpolyper_level1_v4.shp")
classes2 = rgdal::readOGR("selpolyper_level2_v4.shp")
classes3 = rgdal::readOGR("selpolyper_level3_v4.shp")

lidarmetrics_forl1=stack("lidarmetrics_gr_masked.grd")
lidarmetrics_forl23=stack("lidarmetrics_gr_masked_wgr.grd")

featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

# Select coloumns


### Level1 ###

# Classification
level1="level1"
Pred_l1=Classification_werrorass(featuretable_l1,lidarmetrics_forl1,level1)
writeRaster(Pred_l1, filename="classified_level1.tif", format="GTiff",overwrite=TRUE)

Pred_l1=stack("classified_level1.tif")
# Mask 
formask <- setValues(raster(Pred_l1), NA)
formask[Pred_l1==2] <- 1

lidarmetrics_masked1 <- mask(lidarmetrics,formask)
writeRaster(lidarmetrics_masked1, filename="lidarmetrics_forlevel2.grd",overwrite=TRUE)

### Level2 ###

# Intersection
featuretable_l2=Create_Intersection(classes2,lidarmetrics_masked1)
write.table(featuretable_l2,"featuretable_level2_b2o5.csv",row.names=FALSE,sep=",")

# Classification
level2="level2"
Pred_l2=Classification_werrorass(featuretable_l2,lidarmetrics_masked1,level2)
writeRaster(Pred_l2, filename="classified_level2.tif", format="GTiff",overwrite=TRUE)

# Mask 
formask2 <- setValues(raster(Pred_l2), NA)
formask2[Pred_l2==4 | Pred_l2==5] <- 1

lidarmetrics_masked2 <- mask(lidarmetrics_masked1,formask2)
writeRaster(lidarmetrics_masked2, filename="lidarmetrics_forlevel3.grd",overwrite=TRUE)

### Level3 ###

# Intersection
featuretable_l3=Create_Intersection(classes3,lidarmetrics_masked2)
write.table(featuretable_l3,"featuretable_level3_b2o5.csv",row.names=FALSE,sep=",")

# Classification
level3="level3"
Pred_l3=Classification_werrorass(featuretable_l3,lidarmetrics_masked2,level3)
writeRaster(Pred_l3, filename="classified_level3.tif", format="GTiff",overwrite=TRUE)