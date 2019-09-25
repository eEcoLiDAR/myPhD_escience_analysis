library(readxl)

setwd("C:/Koma/Sync/_Amsterdam/11_AndrasProject/hobo_export/hobo_export/sensors_tisza_field_2016_07_06_26_29/")
data <- read_excel("1_10923941_control_outside_wetland.xls",sheet = 1,skip=1)

names(data)<-c('nofmes','date','temp','none')

df <- subset(data, select = c('nofmes','date','temp'))
