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
library(corrplot)

library(usdm)

#source("D:/Koma/GitHub/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")
#source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR_v2/Function_Classification.R")


# Set global variables
#setwd("D:/Koma/Paper1_v2/Run4_2019April/")
setwd("D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_09April/")
#setwd("C:/Koma/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/Results_09April/")

# Import

featuretable_l1=read.csv("featuretable_level1_b2o5.csv")
featuretable_l2=read.csv("featuretable_level2_b2o5.csv")
featuretable_l3=read.csv("featuretable_level3_b2o5.csv")

# Pre-process - rename coloumns, add feature classes

names(featuretable_l1) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l2) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

names(featuretable_l3) <- c("C_puls","C_can","S_curv","S_lin","S_plan","S_sph","S_ani","VV_sd","VV_var","VV_skew","VV_kurt","VV_cr","VV_vdr","VV_simp","VV_shan","HV_rough","HV_tpi","HV_tri",
                            "HV_sd","HV_var","H_max","H_mean","H_med","H_25p","H_75p","H_90p","layer")

#usdm
vifcor_l1=vifcor(as.matrix(featuretable_l1[,1:26]),th=0.9)
vifcor_l2=vifcor(as.matrix(featuretable_l2[,1:26]),th=0.9)
vifcor_l3=vifcor(as.matrix(featuretable_l3[,1:26]),th=0.9)

# Corr. anal

#l1
correlationMatrix <- cor(featuretable_l1[,1:26])
p.mat <- cor.mtest(featuretable_l1[,1:26])

col <- colorRampPalette(c("#77AADD", "#4477AA", "#FFFFFF", "#EE9988","#BB4444"))
corrplot(correlationMatrix, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat, sig.level = 0.01, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.9)

featuretable_l1_ncorr=featuretable_l1[,-sort(highlyCorrelated)]

#l2
correlationMatrix_l2 <- cor(featuretable_l2[,1:26])
p.mat_l2 <- cor.mtest(featuretable_l2[,1:26])

col <- colorRampPalette(c("#77AADD", "#4477AA", "#FFFFFF", "#EE9988","#BB4444"))
corrplot(correlationMatrix_l2, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat_l2, sig.level = 0.01, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

highlyCorrelated_l2 <- findCorrelation(correlationMatrix_l2, cutoff=0.9)

featuretable_l2_ncorr=featuretable_l2[,-sort(highlyCorrelated_l2)]

#l3
correlationMatrix_l3 <- cor(featuretable_l3[,1:26])
p.mat_l3 <- cor.mtest(featuretable_l3[,1:26])

col <- colorRampPalette(c("#77AADD", "#4477AA", "#FFFFFF", "#EE9988","#BB4444"))
corrplot(correlationMatrix_l3, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # Combine with significance
         p.mat = p.mat_l3, sig.level = 0.01, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

highlyCorrelated <- findCorrelation(correlationMatrix_l3, cutoff=0.9)

featuretable_l3_ncorr=featuretable_l3[,-sort(highlyCorrelated)]

# RFE

# level 1
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
#set.seed(50)
rfe_l1 <- rfe(featuretable_l1[,1:26], factor(featuretable_l1$layer), rfeControl=control,sizes=c(1:26),ntree=100,maximize = TRUE)

# level 2
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
set.seed(50)
rfe_l2 <- rfe(featuretable_l2[,1:26], factor(featuretable_l2$layer), rfeControl=control,sizes=c(1:26),ntree=100,maximize = TRUE)

# level 3
control <- rfeControl(functions=rfFuncs, method="cv", number=50,returnResamp = "all")
set.seed(50)
rfe_l3 <- rfe(featuretable_l3[,1:26], factor(featuretable_l3$layer), rfeControl=control,sizes=c(1:26),ntree=100,maximize = TRUE)


absoluteBest_l1 <- pickSizeBest(rfe_l1$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l1 <- pickSizeTolerance(rfe_l1$results, metric = "Accuracy", maximize = TRUE,tol = 1.5)

absoluteBest_l2 <- pickSizeBest(rfe_l2$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l2 <- pickSizeTolerance(rfe_l2$results, metric = "Accuracy", maximize = TRUE,tol = 1.5)

absoluteBest_l3 <- pickSizeBest(rfe_l3$results, metric = "Accuracy", maximize = TRUE)
within5Pct_l3 <- pickSizeTolerance(rfe_l3$results, metric = "Accuracy", maximize = TRUE,tol = 1.5)

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

# Get RF with min number of features

load("rfe_l1_rerank.RData")
load("rfe_l2_rerank.RData")
load("rfe_l3_rerank.RData")

within5Pct_l1 <- pickSizeTolerance(rfe_l1$results, metric = "Accuracy", maximize = TRUE,tol=2.5)
within5Pct_l2 <- pickSizeTolerance(rfe_l2$results, metric = "Accuracy", maximize = TRUE,tol=2.5)
within5Pct_l3 <- pickSizeTolerance(rfe_l3$results, metric = "Accuracy", maximize = TRUE,tol=2.5)

# level 1
trainIndex_l1 <- caret::createDataPartition(y=featuretable_l1$layer, p=0.75, list=FALSE)
trainingSet_l1 <- featuretable_l1[trainIndex_l1,]
testingSet_l1 <- featuretable_l1[-trainIndex_l1,]

modelFit_l1 <- randomForest(trainingSet_l1[,rfe_l1$optVariables[1:within5Pct_l1]],factor(trainingSet_l1$layer),ntree=100,importance = TRUE)
prediction_l1 <- predict(modelFit_l1,testingSet_l1[ ,rfe_l1$optVariables[1:within5Pct_l1]])

conf_m_l1=confusionMatrix(factor(prediction_l1), factor(testingSet_l1$layer),mode = "everything")

# level 2
trainIndex_l2 <- caret::createDataPartition(y=featuretable_l2$layer, p=0.75, list=FALSE)
trainingSet_l2 <- featuretable_l2[trainIndex_l2,]
testingSet_l2 <- featuretable_l2[-trainIndex_l2,]

modelFit_l2 <- randomForest(trainingSet_l2[,rfe_l2$optVariables[1:within5Pct_l2]],factor(trainingSet_l2$layer),ntree=100,importance = TRUE)
prediction_l2 <- predict(modelFit_l2,testingSet_l2[ ,rfe_l2$optVariables[1:within5Pct_l2]])

conf_m_l2=confusionMatrix(factor(prediction_l2), factor(testingSet_l2$layer),mode = "everything")

# level 3
trainIndex_l3 <- caret::createDataPartition(y=featuretable_l3$layer, p=0.75, list=FALSE)
trainingSet_l3 <- featuretable_l3[trainIndex_l3,]
testingSet_l3 <- featuretable_l3[-trainIndex_l3,]

modelFit_l3 <- randomForest(trainingSet_l3[,rfe_l3$optVariables[1:within5Pct_l3]],factor(trainingSet_l3$layer),ntree=100,importance = TRUE)
prediction_l3 <- predict(modelFit_l3,testingSet_l3[ ,rfe_l3$optVariables[1:within5Pct_l3]])

conf_m_l3=confusionMatrix(factor(prediction_l3), factor(testingSet_l3$layer),mode = "everything")

# Export

save(rfe_l1,file = "rfe_l1.RData")
save(rfe_l2,file = "rfe_l2.RData")
save(rfe_l3,file = "rfe_l3.RData")

save(rfe_l1_ncorr,file = "rfe_l1_ncorr.RData")
save(rfe_l2_ncorr,file = "rfe_l2_ncorr.RData")
save(rfe_l3_ncorr,file = "rfe_l3_ncorr.RData")

save(vifcor_l1,file = "vifcor_l1.RData")
save(vifcor_l2,file = "vifcor_l2.RData")
save(vifcor_l3,file = "vifcor_l3.RData")

sink(paste("acc_l1.txt",sep=""))
print(conf_m_l1)
sink()

sink(paste("acc_l2.txt",sep=""))
print(conf_m_l2)
sink()

sink(paste("acc_l3.txt",sep=""))
print(conf_m_l3)
sink()

save(modelFit_l1,file = "modelFit_l1.RData")
save(modelFit_l2,file = "modelFit_l2.RData")
save(modelFit_l3,file = "modelFit_l3.RData")

save(conf_m_l1,file = "conf_m_l1.RData")
save(conf_m_l2,file = "conf_m_l2.RData")
save(conf_m_l3,file = "conf_m_l3.RData")