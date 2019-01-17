"
@author: Zsofia Koma, UvA
Aim: Analyse the results of the classification - feature importance and response curves - functions
"

Analysis_FeatureImportance = function(forest)
{
  library(randomForestExplainer)
  
  importance_frame <- measure_importance(forest)
  
  importance_frame$norm_accuracy_decrease <- (importance_frame$accuracy_decrease-min(importance_frame$accuracy_decrease))/(max(importance_frame$accuracy_decrease)-min(importance_frame$accuracy_decrease))
  importance_frame$norm_gini_decrease <- (importance_frame$gini_decrease-min(importance_frame$gini_decrease))/(max(importance_frame$gini_decrease)-min(importance_frame$gini_decrease))
  
  return(importance_frame)
}

Response_l1 = function(forest_l1,featuretable_l1,id) {
  p1=partialPlot(forest_l1, featuretable_l1, impvar[id], 1)
  p2=partialPlot(forest_l1, featuretable_l1, impvar[id], 2)
  p3=partialPlot(forest_l1, featuretable_l1, impvar[id], 3)
  
  response_l1_c1 <- data.frame(p1[["x"]], p1[["y"]])
  names(response_l1_c1)[1]<-"class_1_x"
  names(response_l1_c1)[2]<-"class_1_y"
  response_l1_c1$class <- 1
  
  response_l1_c2 <- data.frame(p2[["x"]], p2[["y"]])
  names(response_l1_c2)[1]<-"class_1_x"
  names(response_l1_c2)[2]<-"class_1_y"
  response_l1_c2$class <- 2
  
  response_l1_c3 <- data.frame(p3[["x"]], p3[["y"]])
  names(response_l1_c3)[1]<-"class_1_x"
  names(response_l1_c3)[2]<-"class_1_y"
  response_l1_c3$class <- 3
  
  response_l1 <- rbind(response_l1_c1, response_l1_c2, response_l1_c3)
  
  return(response_l1)
}

Response_l2 = function(forest_l1,featuretable_l1,id) {
  p1=partialPlot(forest_l1, featuretable_l1, impvar[id], 1)
  p2=partialPlot(forest_l1, featuretable_l1, impvar[id], 2)
  p3=partialPlot(forest_l1, featuretable_l1, impvar[id], 3)
  p4=partialPlot(forest_l1, featuretable_l1, impvar[id], 4)
  p5=partialPlot(forest_l1, featuretable_l1, impvar[id], 5)
  p6=partialPlot(forest_l1, featuretable_l1, impvar[id], 6)
  
  response_l1_c1 <- data.frame(p1[["x"]], p1[["y"]])
  names(response_l1_c1)[1]<-"class_1_x"
  names(response_l1_c1)[2]<-"class_1_y"
  response_l1_c1$class <- 1
  
  response_l1_c2 <- data.frame(p2[["x"]], p2[["y"]])
  names(response_l1_c2)[1]<-"class_1_x"
  names(response_l1_c2)[2]<-"class_1_y"
  response_l1_c2$class <- 2
  
  response_l1_c3 <- data.frame(p3[["x"]], p3[["y"]])
  names(response_l1_c3)[1]<-"class_1_x"
  names(response_l1_c3)[2]<-"class_1_y"
  response_l1_c3$class <- 3
  
  response_l1_c4 <- data.frame(p4[["x"]], p4[["y"]])
  names(response_l1_c4)[1]<-"class_1_x"
  names(response_l1_c4)[2]<-"class_1_y"
  response_l1_c4$class <- 4
  
  response_l1_c5 <- data.frame(p5[["x"]], p5[["y"]])
  names(response_l1_c5)[1]<-"class_1_x"
  names(response_l1_c5)[2]<-"class_1_y"
  response_l1_c5$class <- 5
  
  response_l1_c6 <- data.frame(p6[["x"]], p6[["y"]])
  names(response_l1_c6)[1]<-"class_1_x"
  names(response_l1_c6)[2]<-"class_1_y"
  response_l1_c6$class <- 3
  
  response_l1 <- rbind(response_l1_c1, response_l1_c2, response_l1_c3, response_l1_c4, response_l1_c5, response_l1_c6)
  
  return(response_l1)
}

