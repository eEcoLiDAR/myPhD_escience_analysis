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
library(Boruta)
library(usdm)
library(randomForestExplainer)

# Set global variables
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/") # working directory
#setwd("D:/Koma/Paper1/ALS/forClassification/")
setwd("D:/Koma/Paper1/ALS/forClassification_v2_run1/")

level1="featuretable_level1_b2o5.csv"

pdf("response_plots_level1.pdf")

# Import

featuretable_l1=read.csv(level1)

# RFE

control <- rfeControl(functions=rfFuncs, method="cv", number=50)
rfe <- rfe(featuretable_l1[,1:28], factor(featuretable_l1$layer), rfeControl=control)
print(rfe, top=10)
plot(rfe, type=c("g", "o"), cex = 1.0,metric="Accuracy")
predictors(rfe)

# plot tree
tree=rpart(layer~.,data = featuretable_l1[c(1:29)], method = "class")
rpart.plot(tree,type=4,cex=0.45)
rpart.rules(tree, cover = TRUE)

#Response

featuretable_l1$O <- factor(ifelse(featuretable_l1$layer==1,"yes","no"))
featuretable_l1$V <- factor(ifelse(featuretable_l1$layer==2,"yes","no"))

#O
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:28)], y=featuretable_l1$O,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = FALSE)

#V
rf.mod <- randomForest(x=featuretable_l1[ ,c(1:28)], y=featuretable_l1$V,importance = TRUE)
class(rf.mod)
varImpPlot(rf.mod)

plotmo(rf.mod, type="prob", nresponse="yes",all1=TRUE,all2 = FALSE)

#Explain forest
forest <- randomForest(x=featuretable_l1[ ,c(1:28)], y=factor(featuretable_l1$layer),importance = TRUE)

#errors
plot(forest, main = "Learning curve of the RF")
legend("topright", c("error for 'O'", "misclassification error", "error for 'V'"), lty = c(1,1,1), col = c("green", "black", "red"))

#Depth
min_depth_frame <- min_depth_distribution(forest)
plot_min_depth_distribution(min_depth_frame)

# Importance
importance_frame <- measure_importance(forest)
head(importance_frame, n = 28)
varImpPlot(forest)

# Multi way importance plot
plot_multi_way_importance(importance_frame, size_measure = "no_of_nodes", min_no_of_trees = 30)

plot_multi_way_importance(importance_frame, x_measure = "accuracy_decrease", y_measure = "gini_decrease")

dev.off()
