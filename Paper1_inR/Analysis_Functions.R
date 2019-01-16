"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves - functions
"

Analysis_FeatureImportance = function(featuretable)
{
  library(randomForest)
  library(randomForestExplainer)
  
  forest <- randomForest(x=featuretable[ ,c(1:28)], y=factor(featuretable$layer),importance = TRUE,ntree = 100)
  importance_frame <- measure_importance(forest)
  
  importance_frame$norm_accuracy_decrease <- (importance_frame$accuracy_decrease-min(importance_frame$accuracy_decrease))/(max(importance_frame$accuracy_decrease)-min(importance_frame$accuracy_decrease))
  importance_frame$norm_gini_decrease <- (importance_frame$gini_decrease-min(importance_frame$gini_decrease))/(max(importance_frame$gini_decrease)-min(importance_frame$gini_decrease))
  
  return(importance_frame)
}

