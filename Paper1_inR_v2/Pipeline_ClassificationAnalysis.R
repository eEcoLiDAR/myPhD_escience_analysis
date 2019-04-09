"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves
"

library(randomForest)
library(caret)

library(ggplot2)
library(gridExtra)
library(ggrepel)

library(reshape2)

#source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")


# Set global variables
#setwd("D:/Koma/Paper1_v2/Run4_2019April/")
setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_05April/")

# Import

featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

# Pre-process - rename coloumns, add feature classes

names(featuretable_l1) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l2) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l3) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

# RFE

# level 1
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
set.seed(50)
rfe_l1 <- rfe(featuretable_l1[,1:26], factor(featuretable_l1$layer), rfeControl=control,sizes=c(1:26),ntree=100)


# level 2
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
set.seed(50)
rfe_l2 <- rfe(featuretable_l2[,1:26], factor(featuretable_l2$layer), rfeControl=control,sizes=c(1:26),ntree=100)

# level 3
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
set.seed(50)
rfe_l3 <- rfe(featuretable_l3[,1:26], factor(featuretable_l3$layer), rfeControl=control,sizes=c(1:26),ntree=100)

rfe_l1_df=data.frame(rfe_l1$results$Variables, rfe_l1$results$Accuracy, rfe_l1$results$AccuracySD)
rfe_l2_df=data.frame(rfe_l2$results$Variables, rfe_l2$results$Accuracy, rfe_l2$results$AccuracySD)
rfe_l3_df=data.frame(rfe_l3$results$Variables, rfe_l3$results$Accuracy, rfe_l3$results$AccuracySD)

p7=ggplot(rfe_l1_df,aes(x=rfe_l1$results$Variables,y=rfe_l1$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_ribbon(aes(ymin=rfe_l1$results$Accuracy-rfe_l1$results$AccuracySD, ymax=rfe_l1$results$Accuracy+rfe_l1$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 1: Vegetation") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))
p8=ggplot(rfe_l2_df,aes(x=rfe_l2$results$Variables,y=rfe_l2$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2)+ geom_ribbon(aes(ymin=rfe_l2$results$Accuracy-rfe_l2$results$AccuracySD, ymax=rfe_l2$results$Accuracy+rfe_l2$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 2: Wetland habitat") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))
p9=ggplot(rfe_l3_df,aes(x=rfe_l3$results$Variables,y=rfe_l3$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2)+ geom_ribbon(aes(ymin=rfe_l3$results$Accuracy-rfe_l3$results$AccuracySD, ymax=rfe_l3$results$Accuracy+rfe_l3$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 3: Reedbed habitat") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))

grid.arrange(
  p7,
  p8,
  p9,
  nrow = 1
)

# Export

save(rfe_l1,file = "rfe_l1.RData")
save(rfe_l2,file = "rfe_l2.RData")
save(rfe_l3,file = "rfe_l3.RData")