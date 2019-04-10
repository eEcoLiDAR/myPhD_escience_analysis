"
@author: Zsofia Koma, UvA
Aim: Classify the data
"
library(raster)
library(rgdal)
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")

# Set working dirctory
workingdirectory="D:/Koma/Paper1_v2/Run4_2019April/"
setwd(workingdirectory)

#Skipped: selection of training data from polygon + buffer and recategorization

# Input

classes1 = rgdal::readOGR("selpolyper_level1_v5.shp")
classes2 = rgdal::readOGR("selpolyper_level2_v5.shp")
classes3 = rgdal::readOGR("selpolyper_level3_v5.shp")

lidarmetrics_forl1=stack("lidarmetrics_l1_masked.grd")
names(lidarmetrics_forl1) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                               "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p")
lidarmetrics_forl23=stack("lidarmetrics_l2l3_masked_wgr.grd")
names(lidarmetrics_forl23) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                               "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p")

featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

names(featuretable_l1) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l2) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l3) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

load("rfe_l1.RData")
load("rfe_l2.RData")
load("rfe_l3.RData")

### Level1 ###

# Classification

Pred_l1=predict(lidarmetrics_forl1, model=rfe_l1$fit, na.rm=TRUE)
writeRaster(Pred_l1, filename="classified_level1.tif", format="GTiff",overwrite=TRUE)

level1="level1"
Classification_werrorass(featuretable_l1,level1,rfe_l1$fit)

# Mask 
formask <- setValues(raster(lidarmetrics_forl23), NA)
formask[Pred_l1==2] <- 1

lidarmetrics_masked1 <- mask(lidarmetrics_forl23,formask)
#writeRaster(lidarmetrics_masked1, filename="lidarmetrics_forlevel2.grd",overwrite=TRUE)

### Level2 ###

# Classification

Pred_l2=predict(lidarmetrics_masked1, model=rfe_l2$fit, na.rm=TRUE)
writeRaster(Pred_l2, filename="classified_level2.tif", format="GTiff",overwrite=TRUE)

level1="level2"
Classification_werrorass(featuretable_l2,level1,rfe_l2$fit)

# Mask 
formask2 <- setValues(raster(lidarmetrics_forl23), NA)
#formask2[Pred_l2==4 | Pred_l2==5] <- 1
formask2[Pred_l2==3] <- 1

lidarmetrics_masked2 <- mask(lidarmetrics_masked1,formask2)
#writeRaster(lidarmetrics_masked2, filename="lidarmetrics_forlevel3.grd",overwrite=TRUE)

### Level3 ###

# Classification

Pred_l3=predict(lidarmetrics_masked2, model=rfe_l3$fit, na.rm=TRUE)
writeRaster(Pred_l3, filename="classified_level3.tif", format="GTiff",overwrite=TRUE)

level1="level3"
Classification_werrorass(featuretable_l3,level1,rfe_l3$fit)