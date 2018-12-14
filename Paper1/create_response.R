"
@author: Zsofia Koma, UvA
Aim: create response curve
"
library(raster)
library(sp)
library(spatialEco)
library(randomForest)
library(caret)
library(pROC)
library(plotmo)

# Set global variables
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
setwd("D:/Koma/Paper1/ALS/forClassification/")

level1="featuretable_level2_b2o5.csv"

lidar="lidarmetrics_forlevel2.grd"

# Import

featuretable=read.csv(level1)

# create binary classification
#Forest
featuretable$forest <- factor(ifelse(featuretable$layer==1,"yes","no"))
featuretable$building <- factor(ifelse(featuretable$layer==2,"yes","no"))
featuretable$grass <- factor(ifelse(featuretable$layer==3,"yes","no"))
featuretable$reed <- factor(ifelse(featuretable$layer==4,"yes","no"))
featuretable$shrub <- factor(ifelse(featuretable$layer==5,"yes","no"))

#Forest
rf.mod <- randomForest(x=featuretable[ ,c(1:22)], y=featuretable$forest,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Reed
rf.mod <- randomForest(x=featuretable[ ,c(1:22)], y=featuretable$reed,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)