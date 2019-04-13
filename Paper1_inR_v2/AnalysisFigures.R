"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves
"

library(randomForest)
library(caret)

library(ggplot2)
library(gridExtra)
library(ggrepel)
library(grid)

library(reshape2)
library(dplyr)

library(sjPlot)

#source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
#source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")

# Set global variables
#setwd("D:/Koma/Paper1_v2/Run4_2019April/")
#setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_09April/")
setwd("C:/Koma/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_09April/")

# Import

#Feature tables
featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

names(featuretable_l1) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l2) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l3) <- c("C_puls","C_can","3S_curv","3S_lin","S_plan","3S_sph","3S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

#RFE
load("rfe_l1_rerank.RData")
load("rfe_l2_rerank.RData")
load("rfe_l3_rerank.RData")

# Conf matrix
load("conf_m_l1.RData")
load("conf_m_l2.RData")
load("conf_m_l3.RData")

# ModelFit
load("modelFit_l1.RData")
load("modelFit_l2.RData")
load("modelFit_l3.RData")

# Way of calculating lidar metrics (boxplots)

# Correlations

# RFE results with feature importance + all ranked feature importance
rfe_l1_df=data.frame(rfe_l1$results$Variables, rfe_l1$results$Accuracy, rfe_l1$results$AccuracySD)
rfe_l2_df=data.frame(rfe_l2$results$Variables, rfe_l2$results$Accuracy, rfe_l2$results$AccuracySD)
rfe_l3_df=data.frame(rfe_l3$results$Variables, rfe_l3$results$Accuracy, rfe_l3$results$AccuracySD)

absoluteBest_l1 <- pickSizeBest(rfe_l1$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l1 <- pickSizeTolerance(rfe_l1$results, metric = "Accuracy", maximize = TRUE)

absoluteBest_l2 <- pickSizeBest(rfe_l2$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l2 <- pickSizeTolerance(rfe_l2$results, metric = "Accuracy", maximize = TRUE)

absoluteBest_l3 <- pickSizeBest(rfe_l3$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l3 <- pickSizeTolerance(rfe_l3$results, metric = "Accuracy", maximize = TRUE)

p1=ggplot(rfe_l1_df,aes(x=rfe_l1$results$Variables,y=rfe_l1$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = within5Pct_l1, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l1$results$Accuracy-rfe_l1$results$AccuracySD, ymax=rfe_l1$results$Accuracy+rfe_l1$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17)) + ggtitle("Results of RFE")
p2=ggplot(rfe_l2_df,aes(x=rfe_l2$results$Variables,y=rfe_l2$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = within5Pct_l2, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l2$results$Accuracy-rfe_l2$results$AccuracySD, ymax=rfe_l2$results$Accuracy+rfe_l2$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17)) + ggtitle("Results of RFE")
p3=ggplot(rfe_l3_df,aes(x=rfe_l3$results$Variables,y=rfe_l3$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = within5Pct_l3, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l3$results$Accuracy-rfe_l3$results$AccuracySD, ymax=rfe_l3$results$Accuracy+rfe_l3$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17)) + ggtitle("Results of RFE")

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)

fea_imp_l1=data.frame("meandecacc"=modelFit_l1$importance[,3],"meandecacc_sd"=modelFit_l1$importanceSD[,3])
fea_imp_l1$variable=rfe_l1$optVariables[1:within5Pct_l1]
fea_imp_l1_clas=add_varclass(fea_imp_l1)

fea_imp_l2=data.frame("meandecacc"=modelFit_l2$importance[,3],"meandecacc_sd"=modelFit_l2$importanceSD[,3])
fea_imp_l2$variable=rfe_l2$optVariables[1:within5Pct_l2]
fea_imp_l2_clas=add_varclass(fea_imp_l2)

fea_imp_l3=data.frame("meandecacc"=modelFit_l3$importance[,3],"meandecacc_sd"=modelFit_l3$importanceSD[,3])
fea_imp_l3$variable=rfe_l3$optVariables[1:within5Pct_l3]
fea_imp_l3_clas=add_varclass(fea_imp_l3)

p4=ggplot(fea_imp_l1_clas, aes(x=reorder(variable,meandecacc),y=meandecacc)) + 
  geom_pointrange(aes(ymin=meandecacc-meandecacc_sd, ymax=meandecacc+meandecacc_sd,color=factor(varclass)),size=1,show.legend = FALSE) + 
  coord_flip() + theme_bw(base_size = 17) +
  xlab("LiDAR metrics") + ylab("Mean Decrease in Accuracy") + 
  theme(axis.text.y=element_text(angle=0,colour = c(rep("black",22), rep("red",4)))) +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage (C_*)","3D shape (3S_*)", "Vertical variability (VV_*)","Height (H_*)","Horizontal variability (HV_*)")) +
  ggtitle("Feature importance")

p5=ggplot(fea_imp_l2_clas, aes(x=reorder(variable,meandecacc),y=meandecacc)) + 
  geom_pointrange(aes(ymin=meandecacc-meandecacc_sd, ymax=meandecacc+meandecacc_sd,color=factor(varclass)),size=1,show.legend = FALSE) + 
  coord_flip() + theme_bw(base_size = 17) +
  xlab("LiDAR metrics") + ylab("Mean Decrease in Accuracy") + 
  theme(axis.text.y=element_text(angle=0,colour = c(rep("black",22), rep("red",4)))) +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage (C_*)","3D shape (3S_*)", "Vertical variability (VV_*)","Height (H_*)","Horizontal variability (HV_*)")) +
  ggtitle("Feature importance")

p6=ggplot(fea_imp_l3_clas, aes(x=reorder(variable,meandecacc),y=meandecacc)) + 
  geom_pointrange(aes(ymin=meandecacc-meandecacc_sd, ymax=meandecacc+meandecacc_sd,color=factor(varclass)),size=1,show.legend = FALSE) + 
  coord_flip() + theme_bw(base_size = 17) +
  xlab("LiDAR metrics") + ylab("Mean Decrease in Accuracy") + 
  theme(axis.text.y=element_text(angle=0,colour = c(rep("black",22), rep("red",4)))) +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage (C_*)","3D shape (3S_*)", "Vertical variability (VV_*)","Height (H_*)","Horizontal variability (HV_*)")) +
  ggtitle("Feature importance")

p0=ggplot(fea_imp_l3_clas, aes(x=reorder(variable,meandecacc),y=meandecacc)) + 
  geom_pointrange(aes(ymin=meandecacc-meandecacc_sd, ymax=meandecacc+meandecacc_sd,color=factor(varclass)),size=1,show.legend = TRUE) + 
  coord_flip() + theme_bw(base_size = 20) +
  xlab("LiDAR metrics") + ylab("Mean Decrease in Accuracy") + 
  theme(axis.text.y=element_text(angle=0,colour = c(rep("black",22), rep("red",4)))) +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage (C_*)","3D shape (S_*)", "Vertical variability (VV_*)","Height (H_*)","Horizontal variability (HV_*)"))

get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(p0)

fig4=grid.arrange(
  p1,
  p4,
  p2,
  p5,
  p3,
  p6,
  legend,
  ncol=3,
  nrow=3,
  layout_matrix=rbind(c(1,2,8), c(3,4,8),c(5,6,8)),
  widths = c(1.25,2,0.8),
  heights = c(3,3,3)
)


fea_bar_l1 <- data.frame(cat=c("C_*", "S_*", "VV_*","H_*","HV_*"),len=c(0,1,0,0,3))
fea_bar_l2 <- data.frame(cat=c("C_*", "S_*", "VV_*","H_*","HV_*"),len=c(1,0,4,6,4))
fea_bar_l3 <- data.frame(cat=c("C_*", "S_*", "VV_*","H_*","HV_*"),len=c(2,1,3,6,3))

p7 = ggplot(fea_bar_l1, aes(x=cat, y=len, fill=cat)) + geom_bar(stat="identity",show.legend = FALSE)+
  theme_bw(base_size = 17) + xlab("Feature class") + ylab("Frequency") +
  scale_fill_manual(values = c("C_*" = "deeppink", "S_*" = "chocolate4", "VV_*" = "blueviolet","H_*"="darkolivegreen3", "HV_*"="blue")) +
  ggtitle("")

p8 = ggplot(fea_bar_l2, aes(x=cat, y=len, fill=cat)) + geom_bar(stat="identity",show.legend = FALSE)+
  theme_bw(base_size = 17) + xlab("Feature class") + ylab("Frequency") +
  scale_fill_manual(values = c("C_*" = "deeppink", "S_*" = "chocolate4", "VV_*" = "blueviolet","H_*"="darkolivegreen3", "HV_*"="blue")) +
  ggtitle("")

p9 = ggplot(fea_bar_l3, aes(x=cat, y=len, fill=cat)) + geom_bar(stat="identity",show.legend = FALSE)+
  theme_bw(base_size = 17) + xlab("Feature class") + ylab("Frequency") +
  scale_fill_manual(values = c("C_*" = "deeppink", "S_*" = "chocolate4", "VV_*" = "blueviolet","H_*"="darkolivegreen3", "HV_*"="blue")) +
  ggtitle("")

t_l1 <- textGrob("Level 1: Vegetation",gp=gpar(fontsize=20, col="black", fontface="bold.italic"))
t_l2 <- textGrob("Level 2: Wetland habitat",gp=gpar(fontsize=20, col="black", fontface="bold.italic"))
t_l3 <- textGrob("Level 3: Reedbed habitat",gp=gpar(fontsize=20, col="black", fontface="bold.italic"))

fig4b=grid.arrange(
  p1,
  p4,
  p2,
  p5,
  p3,
  p6,
  p7,
  p8,
  p9,
  legend,
  t_l1,
  t_l2,
  t_l3,
  ncol=4,
  nrow=6,
  layout_matrix=rbind(c(NA,11,NA,NA),c(1,2,7,10),c(NA,12,NA,NA), c(3,4,8,10),c(NA,13,NA,NA),c(5,6,9,10)),
  widths = c(1.25,2,1,1),
  heights = c(0.2,3,0.2,3,0.2,3)
)

ggsave("Fig4b.png",plot = fig4b,width = 18, height = 18)
  
# Confusion matrices
