library(readxl)
library(data.table)
library(rgdal)

library(ggplot2)
library(scales)
library(gridExtra)

workingdir="C:/Koma/Sync/_Amsterdam/11_AndrasProject/FieldData/"
setwd(workingdir)

data=read.csv("1_sensors_tisza_field_2016_07_26_29.csv")

for (i in seq(1,length(data$hobo))) {
  print(i)
  
  hobo <- read_excel(paste(workingdir,data$dir[i],"/",data$hobo[i],sep=""),sheet = 1,skip=1)
  names(hobo)<-c('nofmes','date','temp','none')
  df <- subset(hobo, select = c('nofmes','date','temp'))
  
  df$date = format(as.POSIXct(df$date,format="%m/%d/%y %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
  
  df$point_name <- data$point_name[i]
  df$veg_type <- data$veg_type[i]
  
  df$temp <- as.numeric(df$temp)
  
  write.csv(df,paste(workingdir,"/1_sensors_tisza_field_2016/",data$water_temp[i],"_",data$class[i],".csv",sep=""))
  
}

setwd(paste(workingdir,"/1_sensors_tisza_field_2016/",sep=""))

files <- list.files(pattern = "*.csv")

allcsv <- lapply(files,function(j){
  read.csv(j, header=TRUE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

ggplot(allcsv_df, aes(x=as.POSIXct(date), y=temp,color=point_name)) + geom_line(size=2) + theme_minimal() +
  scale_x_datetime(labels = date_format("%d/%H:%M"),date_breaks = "5 hours") +
  theme(axis.text.x = element_text(angle=45))+
  xlab("Date")+ylab("Temperature [°C]")

ggsave("1_sensors_tisza_field_2016.png",width = 20, height = 10)