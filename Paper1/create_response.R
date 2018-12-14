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
library(rpart)
library(rpart.plot)

# Set global variables
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
setwd("D:/Koma/Paper1/ALS/forClassification/")

level2="featuretable_level2_b2o5.csv"
level3="featuretable_level3_b2o5.csv"

# Import

featuretable_l1=read.csv(level2)
featuretable_l2=read.csv(level3)

# plot tree
#tree=rpart(layer~.,data = featuretable_l1, method = "class")
#rpart.plot(tree,type=4,cex=0.45,branch=.2)
#rpart.rules(tree, cover = TRUE)

# Level2

featuretable_l1$forest <- factor(ifelse(featuretable_l1$layer==1,"yes","no"))
featuretable_l1$building <- factor(ifelse(featuretable_l1$layer==2,"yes","no"))
featuretable_l1$grass <- factor(ifelse(featuretable_l1$layer==3,"yes","no"))
featuretable_l1$reed <- factor(ifelse(featuretable_l1$layer==4,"yes","no"))
featuretable_l1$shrub <- factor(ifelse(featuretable_l1$layer==5,"yes","no"))

#Forest
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:22)], y=featuretable_l1$forest,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Reed
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:22)], y=featuretable_l1$reed,importance = TRUE,ntree=100)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE)

#Grass
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:22)], y=featuretable_l1$grass,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Shrub
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:22)], y=featuretable_l1$shrub,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Building
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:22)], y=featuretable_l1$building,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Level3

featuretable_l2$Rk <- factor(ifelse(featuretable_l2$layer==1,"yes","no"))
featuretable_l2$Rl <- factor(ifelse(featuretable_l2$layer==2,"yes","no"))
featuretable_l2$Rw <- factor(ifelse(featuretable_l2$layer==3,"yes","no"))
featuretable_l2$U <- factor(ifelse(featuretable_l2$layer==4,"yes","no"))

#Rk
rf.mod <- randomForest(x=featuretable_l2[ ,c(1:22)], y=featuretable_l2$Rk,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Rl
rf.mod <- randomForest(x=featuretable_l2[ ,c(1:22)], y=featuretable_l2$Rl,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#Rw
rf.mod <- randomForest(x=featuretable_l2[ ,c(1:22)], y=featuretable_l2$Rw,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)

#U
rf.mod <- randomForest(x=featuretable_l2[ ,c(1:22)], y=featuretable_l2$U,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = TRUE)
