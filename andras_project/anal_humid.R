"
@author: Zsofia Koma, UvA
Aim: process wetland OTKA project data step 3.: analysis of humidity and tempreture data + visulaize it
"

library(readxl)
library(data.table)
library(rgdal)

library(ggplot2)
library(scales)
library(gridExtra)

workingdir="D:/Sync/_Amsterdam/11_AndrasProject/balaton/"
locations=c("fuzfo","mariafurdo","sajkod","szantod","szigliget")

for (filename in locations) {
  print(filename)
  
  setwd(paste(workingdir,"/",filename,"/",sep=""))
  
  masterlist=list.files(pattern="*humid.csv")
  
  for (master in masterlist) {
    print(master)
    data=read.csv(master)
    id=sub("_.*", "", master)
    
    for (i in seq(1,length(data$easylog))) {
      print(i)
      
      easylog <- read.csv(paste(data$easylog[i],sep=""))
      names(easylog)<-c('nofmes','date','temp','humidity','devpoint','none')
      df <- subset(easylog, select = c('nofmes','date','temp','humidity'))
      
      df$date = format(as.POSIXct(df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
      
      df=df[which(df$date>as.POSIXct(data$startdate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
      df=df[which(df$date<as.POSIXct(data$enddate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
      
      if(length(df$date)==0) next
      
      df$point_name <- data$point_name[i]
      df$veg_type <- data$veg_type[i]
      
      df$temp <- as.numeric(df$temp)
      df$humidity <- as.numeric(df$humidity)
      
      write.csv(df,paste(data$transectid[i],"_",data$water_temp[i],"humid_cleaned",".csv",sep=""))
      
      data$min_airtemp[i] <- min(df$temp)
      data$max_airtemp[i] <- max(df$temp)
      data$range_airtemp[i] <- max(df$temp)-min(df$temp)
      data$mean_airtemp[i] <- mean(df$temp)
      
      data$min_airhum[i] <- min(df$humidity)
      data$max_airhum[i] <- max(df$humidity)
      data$range_airhum[i] <- max(df$humidity)-min(df$humidity)
      data$mean_airhum[i] <- mean(df$humidity)
      
    }
    
    # Normalize
    controlid=grep("control", data$point_name)
    
    data$diff_min_airtemp <- data$min_airtemp-data$min_airtemp[controlid[as.numeric(id)]]
    data$diff_max_airtemp <- data$max_airtemp-data$max_airtemp[controlid[as.numeric(id)]]
    data$diff_range_airtemp <- data$range_airtemp-data$range_airtemp[controlid[as.numeric(id)]]
    data$diff_mean_airtemp <- data$mean_airtemp-data$mean_airtemp[controlid[as.numeric(id)]]
    
    data$diff_min_airhum <- data$min_airhum-data$min_airhum[controlid[as.numeric(id)]]
    data$diff_max_airhum <- data$max_airhum-data$max_airhum[controlid[as.numeric(id)]]
    data$diff_range_airhum <- data$range_airhum-data$range_airhum[controlid[as.numeric(id)]]
    data$diff_mean_airhum <- data$mean_airhum-data$mean_airhum[controlid[as.numeric(id)]]
    
    write.csv(data,paste(data$transectid[1],"_humid_final_",id,".csv",sep=""))
    
    subdata <- subset(data, select = c("OBJNAME","transectid","point_name","class","distcont","min_airtemp","max_airtemp","range_airtemp","mean_airtemp","min_airhum","max_airhum","range_airhum",
                                       "mean_airhum","diff_min_airtemp","diff_max_airtemp","diff_range_airtemp","diff_mean_airtemp","diff_min_airhum","diff_max_airhum","diff_range_airhum","diff_mean_airhum"))
    subdata$control <- data$point_name[controlid[as.numeric(id)]]
    
    write.csv(subdata,paste(workingdir,data$transectid[1],"_",id,"_humid_final_cleaned",".csv",sep=""))
    
    # Visualize
    files <- list.files(pattern = paste("humid_cleaned",".csv",sep=""))
    
    allcsv <- lapply(files,function(j){
      read.csv(j, header=TRUE)
    })
    
    allcsv_df <- do.call(rbind.data.frame, allcsv)
    
    allcsv_df=allcsv_df[!is.na(allcsv_df$point_name), ]
    
    ggplot(allcsv_df, aes(x=as.POSIXct(date), y=temp,color=point_name)) + geom_line(size=2) + theme_minimal() +
      scale_x_datetime(labels = date_format("%d/%H:%M"),date_breaks = "5 hours") +
      theme(axis.text.x = element_text(angle=45))+
      xlab("Date")+ylab("Air temperature [°C]")
    
    ggsave(paste(data$transectid[1],"airtemp.png",sep=""),width = 20, height = 10)
    
    ggplot(allcsv_df, aes(x=as.POSIXct(date), y=humidity,color=point_name)) + geom_line(size=2) + theme_minimal() +
      scale_x_datetime(labels = date_format("%d/%H:%M"),date_breaks = "5 hours") +
      theme(axis.text.x = element_text(angle=45))+
      xlab("Date")+ylab("Humidity [%rh]")
    
    ggsave(paste(data$transectid[1],"airhum.png",sep=""),width = 20, height = 10)
    
  }
  
}