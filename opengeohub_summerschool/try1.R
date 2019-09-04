
library(readxl)
library(raster)
library(caret)

setwd("D:/Koma/summerschool/")
train_data <- read_excel("SpatialPrediction.xlsx",sheet = 1)
support_data <- read_excel("SpatialPrediction.xlsx",sheet = 2)
spatialinfo <- read_excel("SpatialPrediction.xlsx",sheet = 3)
test_data <- read_excel("SpatialPrediction.xlsx",sheet = 4)

as.POSIXct(train_data$time)

# by time
train_onetime=train_data[train_data$time=="2019-04-02 00:00:00 UTC",]
redsupport=support_data[support_data$time=="2019-04-02 00:00:00 UTC",]

train_onetime_sp=merge(x = train_onetime, y = spatialinfo, by = "id", all.x = TRUE)
train_onetime_sp_wsup=merge(x = train_onetime_sp, y = redsupport, by = "id", all.x = TRUE)

ctrl <- trainControl(method="cv", 
                     number =10, 
                     savePredictions = TRUE)

set.seed(100)
model <- train(train_onetime_sp_wsup[,c(7,8)],
               train_onetime_sp_wsup[,3],
               method="rpart",
               metric="rmse",
               trControl=ctrl)
print(model)

# by location
train_oneloc=train_data[train_data$id=="5b1d358a1fef04001b04f199",]
redsupport_oneloc=support_data[support_data$id=="5b1d358a1fef04001b04f199",]

plot(redsupport_oneloc$time,redsupport_oneloc$humidity)
plot(train_oneloc$time,train_oneloc$PM10)
