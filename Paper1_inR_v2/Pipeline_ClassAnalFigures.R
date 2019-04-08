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

#source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")


# Set global variables
#setwd("D:/Koma/Paper1_v2/Run4_2019April/")
setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_05April/")

# Import

load("forest_l1.RData")
load("forest_l2.RData")
load("forest_l3.RData")

load("rfe_l1.RData")
load("rfe_l2.RData")
load("rfe_l3.RData")

# Fig.4. : Feature Importance

importance_frame_l1=Analysis_FeatureImportance(forest_l1)
importance_frame_l2=Analysis_FeatureImportance(forest_l2)
importance_frame_l3=Analysis_FeatureImportance(forest_l3)

importance_frame_l1_m=add_varclass(importance_frame_l1)
importance_frame_l2_m=add_varclass(importance_frame_l2)
importance_frame_l3_m=add_varclass(importance_frame_l3)

data_l1 <- importance_frame_l1_m[importance_frame_l1_m$no_of_trees > 0, ]
data_for_labels_l1 <- importance_frame_l1_m[importance_frame_l1_m$variable %in%
                                              important_variables(importance_frame_l1_m, k = 5,
                                                                  measures = c("norm_accuracy_decrease","norm_gini_decrease")), ]

data_l2 <- importance_frame_l2_m[importance_frame_l2_m$no_of_trees > 0, ]
data_for_labels_l2 <- importance_frame_l2_m[importance_frame_l2_m$variable %in%
                                              important_variables(importance_frame_l2_m, k = 4,
                                                                  measures = c("norm_accuracy_decrease","norm_gini_decrease")), ]

data_l3 <- importance_frame_l3_m[importance_frame_l3_m$no_of_trees > 0, ]
data_for_labels_l3 <- importance_frame_l3_m[importance_frame_l3_m$variable %in%
                                              important_variables(importance_frame_l3_m, k = 12,
                                                                  measures = c("norm_accuracy_decrease","norm_gini_decrease")), ]

p0=ggplot(data_l1, aes_string(x = "norm_accuracy_decrease", y = "norm_gini_decrease")) +
  geom_point(aes(color=factor(data_l1$varclass)),size=5,show.legend = TRUE) + geom_point(data = data_l1, aes(color=factor(data_l1$varclass)),size=5,show.legend = FALSE) +
  geom_text_repel(data = data_for_labels_l1, aes(label = variable,size=30), show.legend = FALSE, size=5,box.padding=0.5) +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage (C_*)","3D shape (3S_*)", "Vertical variability (VV_*)","Height (H_*)","Horizontal variability (HV_*)")) +
  xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease") +
  theme_bw(base_size = 20) + ylim(0, 1) + xlim(0, 1) + theme(legend.position="right")

p1=ggplot(data_l1, aes_string(x = "norm_accuracy_decrease", y = "norm_gini_decrease")) +
  geom_point(aes(color=factor(data_l1$varclass)),size=5,show.legend = FALSE) + geom_point(data = data_l1, aes(color=factor(data_l1$varclass)),size=5,show.legend = FALSE) +
  geom_text_repel(data = data_for_labels_l1, aes(label = variable,size=15), show.legend = FALSE, size=5,box.padding=0.5,direction="both") +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage","3D shape", "Vertical variability","Height","Horizontal variability")) +
  xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease") +
  theme_bw(base_size = 17) + ylim(0, 1) + xlim(0, 1)

p2=ggplot(data_l2, aes_string(x = "norm_accuracy_decrease", y = "norm_gini_decrease")) +
  geom_point(aes(color=factor(data_l2$varclass)),size=5,show.legend = FALSE) + geom_point(data = data_l2, aes(color=factor(data_l2$varclass)),size=5,show.legend = FALSE) +
  geom_text_repel(data = data_for_labels_l2, aes(label = variable,size=15), show.legend = FALSE, size=5,box.padding=0.5,direction="both") +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage","3D shape", "Vertical variability","Height","Horizontal variability")) +
  xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease") +
  theme_bw(base_size = 17) + ylim(0, 1) + xlim(0, 1)

p3=ggplot(data_l3, aes_string(x = "norm_accuracy_decrease", y = "norm_gini_decrease")) +
  geom_point(aes(color=factor(data_l3$varclass)),size=5,show.legend = FALSE) + geom_point(data = data_l3, aes(color=factor(data_l3$varclass)),size=5,show.legend = FALSE) +
  geom_text_repel(data = data_for_labels_l3, aes(label = variable,size=15), show.legend = FALSE, size=5,box.padding=0.5,direction="both") +
  scale_color_manual(values = c("1" = "deeppink", "2" = "chocolate4", "3" = "blueviolet","4"="darkolivegreen3", "5"="blue"),name="Feature class",labels=c("Coverage","3D shape", "Vertical variability","Height","Horizontal variability")) +
  xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease") +
  theme_bw(base_size = 17) + ylim(0, 1) + xlim(0, 1)

get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

legend <- get_legend(p0)

grid.arrange(
  p1,
  p2,
  p3,
  legend,
  ncol=4,
  nrow=1,
  layout_matrix=rbind(c(1,2,3,4)),
  widths = c(2.5, 2.5,2.5,2.5)
)

# Fig3: RFE

rfe_l1_df=data.frame(rfe_l1$results$Variables, rfe_l1$results$Accuracy, rfe_l1$results$AccuracySD)
rfe_l2_df=data.frame(rfe_l2$results$Variables, rfe_l2$results$Accuracy, rfe_l2$results$AccuracySD)
rfe_l3_df=data.frame(rfe_l3$results$Variables, rfe_l3$results$Accuracy, rfe_l3$results$AccuracySD)

p7=ggplot(rfe_l1_df,aes(x=rfe_l1$results$Variables,y=rfe_l1$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = 5, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l1$results$Accuracy-rfe_l1$results$AccuracySD, ymax=rfe_l1$results$Accuracy+rfe_l1$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 1: Vegetation") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))
p8=ggplot(rfe_l2_df,aes(x=rfe_l2$results$Variables,y=rfe_l2$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = 5, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l2$results$Accuracy-rfe_l2$results$AccuracySD, ymax=rfe_l2$results$Accuracy+rfe_l2$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 2: Wetland habitat") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))
p9=ggplot(rfe_l3_df,aes(x=rfe_l3$results$Variables,y=rfe_l3$results$Accuracy))+geom_point(color="black",size=3) + geom_line(color="black",size=2) + geom_vline(xintercept = 12, color="red", size=2) + geom_ribbon(aes(ymin=rfe_l3$results$Accuracy-rfe_l3$results$AccuracySD, ymax=rfe_l3$results$Accuracy+rfe_l3$results$AccuracySD), linetype=2, alpha=0.1) + xlab("Number of LiDAR metrics") + ylab("Accuracy") + ylim(0, 1) + ggtitle("Level 3: Reedbed habitat") + theme_bw(base_size = 17) + theme(plot.title = element_text(size=17))

grid.arrange(
  p7,
  p8,
  p9,
  nrow = 1
)

fig4=grid.arrange(
  p7,
  p1,
  p8,
  p2,
  p9,
  p3,
  legend,
  ncol=3,
  nrow=3,
  layout_matrix=rbind(c(1,2,8), c(3,4,8),c(5,6,8)),
  widths = c(1.25,2,0.8),
  heights = c(2,2,2),
  top = textGrob("Results of Recursive Feature Elimination (RFE)",gp=gpar(fontsize=20,font=3))
)

ggsave("Fig4.png",plot = fig4,width = 16, height = 18)