"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves
"
library(gridExtra)
source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR/Analysis_Functions.R")

# Set global variables
setwd("D:/Koma/Paper1_ReedStructure/run_withR_2019Jan/")

level1="featuretable_level1_b2o5.csv"
level2="featuretable_level2_b2o5.csv"
level3="featuretable_level3_b2o5.csv"

# Import
featuretable_l1=read.csv(level1)
featuretable_l2=read.csv(level2)
featuretable_l3=read.csv(level3)

# Fig.5. : Feature Importance

importance_frame_l1=Analysis_FeatureImportance(featuretable_l1)
importance_frame_l2=Analysis_FeatureImportance(featuretable_l2)
importance_frame_l3=Analysis_FeatureImportance(featuretable_l3)

p1=plot_multi_way_importance(importance_frame_l1, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 1') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")
p2=plot_multi_way_importance(importance_frame_l2, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 2') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")
p3=plot_multi_way_importance(importance_frame_l3, x_measure = "norm_accuracy_decrease", y_measure = "norm_gini_decrease", main='Level 3') + xlab("Normalized accuracy decrease") + ylab("Normalized gini decrease")

grid.arrange(
  p1,
  p2,
  p3,
  nrow = 1
)

# Fig.6. Response curves related to the most important feature sper classes 