"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves
"

library(randomForest)
library(caret)

library(ggplot2)
library(gridExtra)
source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR/Analysis_Functions.R")
#source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/Analysis_Functions.R")

# Set global variables
setwd("D:/Koma/Paper1/ALS/forClassification_run4/")
#setwd("C:/Koma/Paper1/run2_withR_2019Jan/")

level1="featuretable_level1_b2o5.csv"
level2="featuretable_level2_b2o5.csv"
level3="featuretable_level3_b2o5.csv"

# Import

featuretable_l1=read.csv(level1)
featuretable_l2=read.csv(level2)
featuretable_l3=read.csv(level3)

# RF
forest_l1 <- randomForest(x=featuretable_l1[ ,c(1:39)], y=factor(featuretable_l1$layer),importance = TRUE,ntree = 100)
forest_l2 <- randomForest(x=featuretable_l2[ ,c(1:44)], y=factor(featuretable_l2$layer),importance = TRUE,ntree = 100)
forest_l3 <- randomForest(x=featuretable_l3[ ,c(1:44)], y=factor(featuretable_l3$layer),importance = TRUE,ntree = 100)

#Save it
save(forest_l1,file = "forest_l1.RData")
save(forest_l2,file = "forest_l2.RData")
save(forest_l3,file = "forest_l3.RData")

#load("forest_l1.RData")

# Fig.5. : Feature Importance

importance_frame_l1=Analysis_FeatureImportance(forest_l1)
importance_frame_l2=Analysis_FeatureImportance(forest_l2)
importance_frame_l3=Analysis_FeatureImportance(forest_l3)

p1=plot_multi_way_importance(importance_frame_l1, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 1') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")
p2=plot_multi_way_importance(importance_frame_l2, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 2') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")
p3=plot_multi_way_importance(importance_frame_l3, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 3') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)

# Fig.6. v1. Partial dependence plots related to the most important features per classes 

# level 1
imp <- importance(forest_l1)
impvar <- rownames(imp)[order(imp[, 4], decreasing=TRUE)]

id=1
response_l1_imp1 <- Response_l1(forest_l1,featuretable_l1,id)
id=5
response_l1_imp2 <- Response_l1(forest_l1,featuretable_l1,id)
id=12
response_l1_imp3 <- Response_l1(forest_l1,featuretable_l1,id)

p4=ggplot(response_l1_imp1,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[1]) + ylab("Partial dependence") + scale_color_manual(values = c("1" = "gray", "2" = "green"),name="General classes",labels=c("Planar surface", "Vegetation")) + theme_bw(base_size = 20)
p5=ggplot(response_l1_imp2,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[5]) + ylab("Partial dependence") + scale_color_manual(values = c("1" = "gray", "2" = "green"),name="General classes",labels=c("Planar surface", "Vegetation")) + theme_bw(base_size = 20)
p6=ggplot(response_l1_imp3,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[12]) + ylab("Partial dependence") + scale_color_manual(values = c("1" = "gray", "2" = "green"),name="General classes",labels=c("Planar surface", "Vegetation")) + theme_bw(base_size = 20)

grid.arrange(
  p4,
  p5,
  p6,
  nrow = 1
)

# level 2
imp <- importance(forest_l2)
impvar <- rownames(imp)[order(imp[, 4], decreasing=TRUE)]

id=7
response_l2_imp1 <- Response_l2(forest_l2,featuretable_l2,id)
id=20
response_l2_imp2 <- Response_l2(forest_l2,featuretable_l2,id)
id=11
response_l2_imp3 <- Response_l2(forest_l2,featuretable_l2,id)

p4=ggplot(response_l2_imp1,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[7]) + ylab("Partial dependence")+ scale_color_manual(values = c("1" = "darkgreen", "2" = "gray46", "3" = "green1","4"="gold","5"="chocolate4","6"="darkolivegreen4"),
                                                                                                                                                                    name="Wetland",labels=c("Forest", "Infrastructure","Grassland","Land reed","Water reed","Shrubs")) + theme_bw(base_size = 20)
p5=ggplot(response_l2_imp2,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[20]) + ylab("Partial dependence")+ scale_color_manual(values = c("1" = "darkgreen", "2" = "gray46", "3" = "green1","4"="gold","5"="chocolate4","6"="darkolivegreen4"),
                                                                                                                                                                     name="Wetland",labels=c("Forest", "Infrastructure","Grassland","Land reed","Water reed","Shrubs")) + theme_bw(base_size = 20)
p6=ggplot(response_l2_imp3,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[11]) + ylab("Partial dependence")+ scale_color_manual(values = c("1" = "darkgreen", "2" = "gray46", "3" = "green1","4"="gold","5"="chocolate4","6"="darkolivegreen4"),
                                                                                                                                                                     name="Wetland",labels=c("Forest", "Infrastructure","Grassland","Land reed","Water reed","Shrubs")) + theme_bw(base_size = 20)

grid.arrange(
  p4,
  p5,
  p6,
  nrow = 1
)

#level 3
imp <- importance(forest_l3)
impvar <- rownames(imp)[order(imp[, 4], decreasing=TRUE)]

id=1
response_l3_imp1 <- Response_l3(forest_l3,featuretable_l3,id)
id=9
response_l3_imp2 <- Response_l3(forest_l3,featuretable_l3,id)
id=10
response_l3_imp3 <- Response_l3(forest_l3,featuretable_l3,id)

p4=ggplot(response_l3_imp1,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[1]) + ylab("Partial dependence")+ scale_color_manual(values = c("1"="gold","2"="tan2","3"="chocolate4"),name="Reedbed",labels=c("Land reed rich","Land reed poor","Water reed")) + theme_bw(base_size = 20)
p5=ggplot(response_l3_imp2,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[9]) + ylab("Partial dependence")+ scale_color_manual(values = c("1"="gold","2"="tan2","3"="chocolate4"),name="Reedbed",labels=c("Land reed rich","Land reed poor","Water reed")) + theme_bw(base_size = 20)
p6=ggplot(response_l3_imp3,aes(x=class_1_x,y=class_1_y,color=factor(class))) + geom_line(size=2) + xlab(impvar[10]) + ylab("Partial dependence")+ scale_color_manual(values = c("1"="gold","2"="tan2","3"="chocolate4"),name="Reedbed",labels=c("Land reed rich","Land reed poor","Water reed")) + theme_bw(base_size = 20)

grid.arrange(
  p4,
  p5,
  p6,
  nrow = 1
)

# Fig.6. v2. : response curves with probabilities


# RFE
# level 1
control <- rfeControl(functions=rfFuncs, method="cv", number=50)
rfe_l1 <- rfe(featuretable_l1[,1:39], factor(featuretable_l1$layer), rfeControl=control)

# level 2
control <- rfeControl(functions=rfFuncs, method="cv", number=50)
rfe_l2 <- rfe(featuretable_l2[,1:39], factor(featuretable_l2$layer), rfeControl=control)

# level 3
control <- rfeControl(functions=rfFuncs, method="cv", number=50)
rfe_l3 <- rfe(featuretable_l3[,1:39], factor(featuretable_l3$layer), rfeControl=control)

rfe_l1_df=data.frame(rfe_l1$results$Variables, rfe_l1$results$Accuracy, rfe_l1$results$AccuracySD)
rfe_l2_df=data.frame(rfe_l2$results$Variables, rfe_l2$results$Accuracy, rfe_l2$results$AccuracySD)
rfe_l3_df=data.frame(rfe_l3$results$Variables, rfe_l3$results$Accuracy, rfe_l3$results$AccuracySD)

p7=ggplot(rfe_l1_df,aes(x=rfe_l1$results$Variables,y=rfe_l1$results$Accuracy))+geom_point(color="blue",size=2) + geom_line(color="blue",size=1)+ geom_ribbon(aes(ymin=rfe_l1$results$Accuracy-rfe_l1$results$AccuracySD, ymax=rfe_l1$results$Accuracy+rfe_l1$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 1") + theme_bw(base_size = 20)
p8=ggplot(rfe_l2_df,aes(x=rfe_l2$results$Variables,y=rfe_l2$results$Accuracy))+geom_point(color="blue",size=2) + geom_line(color="blue",size=1)+ geom_ribbon(aes(ymin=rfe_l2$results$Accuracy-rfe_l2$results$AccuracySD, ymax=rfe_l2$results$Accuracy+rfe_l2$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 2") + theme_bw(base_size = 20)
p9=ggplot(rfe_l3_df,aes(x=rfe_l3$results$Variables,y=rfe_l3$results$Accuracy))+geom_point(color="blue",size=2) + geom_line(color="blue",size=1)+ geom_ribbon(aes(ymin=rfe_l3$results$Accuracy-rfe_l3$results$AccuracySD, ymax=rfe_l3$results$Accuracy+rfe_l3$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 3") + theme_bw(base_size = 20)

grid.arrange(
  p7,
  p8,
  p9,
  nrow = 1
)
