"
@author: Zsofia Koma, UvA
Aim: Prepare training data
"

library(raster)
library(rgdal)
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")

# Set working dirctory
workingdirectory="D:/Koma/Paper1_v2/Run1_2019March/Classification/"
setwd(workingdirectory)

# Generate training data from polygon file

# Create intersection

# Input

classes1 = rgdal::readOGR("selpolyper_level1_v4.shp")
classes2 = rgdal::readOGR("selpolyper_level2_v4.shp")
classes3 = rgdal::readOGR("selpolyper_level3_v4.shp")

lidarmetrics=stack("lidarmetrics_gr_masked_wgr.grd")

# Intersection
featuretable_l1=Create_Intersection(classes1,lidarmetrics)
write.table(featuretable_l1,"featuretable_level1_b2o5.csv",row.names=FALSE,sep=",")

featuretable_l2=Create_Intersection(classes2,lidarmetrics)
write.table(featuretable_l2,"featuretable_level2_b2o5.csv",row.names=FALSE,sep=",")

featuretable_l3=Create_Intersection(classes3,lidarmetrics)
write.table(featuretable_l3,"featuretable_level3_b2o5.csv",row.names=FALSE,sep=",")