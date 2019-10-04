library(readxl)
library(data.table)
library(rgdal)

library(ggplot2)
library(scales)
library(gridExtra)

workingdir="D:/Sync/_Amsterdam/11_AndrasProject/tisza/2017_poroszlo/"
setwd(workingdir)

masterlist=list.files(pattern="*masterfile.csv")

data=read.csv(masterlist[1])

for (i in seq(1,length(data$hobo))) {
  print(i)
  
  hobo <- read_excel(paste(data$dir[i],"/",data$hobo[i],sep=""),sheet = 1,skip=1)
  names(hobo)<-c('nofmes','date','temp','none')
  df <- subset(hobo, select = c('nofmes','date','temp'))
  
  df$date = format(as.POSIXct(df$date,format="%m/%d/%y %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
  
  df=df[which(df$date>as.POSIXct(data$startdate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
  df=df[which(df$date<as.POSIXct(data$enddate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
  
  df$point_name <- data$point_name[i]
  df$veg_type <- data$veg_type[i]
  
  df$temp <- as.numeric(df$temp)
  
  write.csv(df,paste(workingdir,data$transectid[i],"_",data$water_temp[i],"_cleaned.csv",sep=""))
  
  data$min_temp[i] <- min(df$temp)
  data$max_temp[i] <- max(df$temp)
  data$range_temp[i] <- range(df$temp)
  data$mean_temp[i] <- mean(df$temp)
  
}

# Visualize
files <- list.files(pattern = "*cleaned.csv")

allcsv <- lapply(files,function(j){
  read.csv(j, header=TRUE)
})

allcsv_df <- do.call(rbind.data.frame, allcsv)

ggplot(allcsv_df, aes(x=as.POSIXct(date), y=temp,color=point_name)) + geom_line(size=2) + theme_minimal() +
  scale_x_datetime(labels = date_format("%d/%H:%M"),date_breaks = "5 hours") +
  theme(axis.text.x = element_text(angle=45))+
  xlab("Date")+ylab("Water temperature [°C]")

ggsave(paste(data$transectid[1],".png",sep=""),width = 20, height = 10)

# Normalize
controlid=grep("control", data$point_name)

data$diff_min_temp2 <- data$min_temp-data$min_temp[controlid[2]]
data$diff_max_temp2 <- data$max_temp-data$max_temp[controlid[2]]
data$diff_range_temp2 <- data$range_temp-data$range_temp[controlid[2]]
data$diff_mean_temp2 <- data$mean_temp-data$mean_temp[controlid[2]]

write.csv(data,paste(workingdir,data$transectid[1],"_masterfile_final.csv",sep=""))

