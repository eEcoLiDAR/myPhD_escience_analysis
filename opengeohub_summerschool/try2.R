library(readxl)
library(raster)
library(caret)

setwd("D:/Koma/summerschool/")
train_data <- read_excel("SpatialPrediction.xlsx",sheet = 1)
support_data <- read_excel("SpatialPrediction.xlsx",sheet = 2)
spatialinfo <- read_excel("SpatialPrediction.xlsx",sheet = 3)
test_data <- read_excel("SpatialPrediction.xlsx",sheet = 4)

as.POSIXct(train_data$time)

train_wsp=merge(x = train_data, y = spatialinfo, by = "id", all.x = TRUE)
train_wsp_pred=merge(x = train_wsp, y = support_data, by = c("id","time"), all.x = TRUE)

train_wsp_pred$hour=as.numeric(strftime(train_wsp_pred$time, format="%H"))

as.POSIXct(test_data$time)

test_wsp=merge(x = test_data, y = spatialinfo, by = "id", all.x = TRUE)
test_wsp_pred=merge(x = test_wsp, y = support_data, by = c("id","time"), all.x = TRUE)

test_wsp_pred$hour=as.numeric(strftime(test_wsp_pred$time, format="%H"))

ctrl <- trainControl(method="cv", 
                     number =10, 
                     savePredictions = TRUE)

set.seed(100)
model <- train(train_wsp_pred[1:100,c(4,5,6,7,8)],
               train_wsp_pred[1:100,3],
               method="rf",
               metric="rmse",
               importance = TRUE,
               trControl=ctrl)
print(model)

predict(test_data)

pred=predict(model,test_wsp_pred[c(3,4,5,6,7)])

test_wsp_pred$PM10_pred <- pred

test_wsp_pred_oneloc=test_wsp_pred[test_wsp_pred$id=="5750220bed08f9680c6b4154",]
plot(test_wsp_pred_oneloc$time,test_wsp_pred_oneloc$PM10)
