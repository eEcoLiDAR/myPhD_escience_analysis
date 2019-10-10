"
@author: Zsofia Koma, UvA
Aim: process wetland OTKA project data step 3.: analysis of water tempreture data + visulaize it
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
  
  masterlist=list.files(pattern="*watertemp.csv")
  
  for (master in masterlist) {
    print(master)
    data=read.csv(master)
    id=sub("_.*", "", master)
    
    for (i in seq(1,length(data$hobo))) {
      print(i)
      
      hobo <- read_excel(paste(data$hobo[i],sep=""),sheet = 1,skip=1)
      names(hobo)<-c('nofmes','date','temp','none')
      df <- subset(hobo, select = c('nofmes','date','temp'))
      
      df$date = format(as.POSIXct(df$date,format="%m/%d/%y %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
      
      df=df[which(df$date>as.POSIXct(data$startdate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
      df=df[which(df$date<as.POSIXct(data$enddate[1],format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())),]
      
      df$point_name <- data$point_name[i]
      df$veg_type <- data$veg_type[i]
      
      df$temp <- as.numeric(df$temp)
      
      write.csv(df,paste(data$transectid[i],"_",data$water_temp[i],"watertemp_cleaned",".csv",sep=""))
      
      data$min_temp[i] <- min(df$temp)
      data$max_temp[i] <- max(df$temp)
      data$range_temp[i] <- range(df$temp)
      data$mean_temp[i] <- mean(df$temp)
      
    }
    
    # Normalize
    controlid=grep("control", data$point_name)
    
    data$diff_min_temp <- data$min_temp-data$min_temp[controlid[as.numeric(id)]]
    data$diff_max_temp <- data$max_temp-data$max_temp[controlid[as.numeric(id)]]
    data$diff_range_temp <- data$range_temp-data$range_temp[controlid[as.numeric(id)]]
    data$diff_mean_temp <- data$mean_temp-data$mean_temp[controlid[as.numeric(id)]]
    
    write.csv(data,paste(data$transectid[1],"_watertemp_final_",id,".csv",sep=""))
    
    subdata <- subset(data, select = c("OBJNAME","transectid","point_name","class","distcont","min_temp","max_temp","range_temp","mean_temp","diff_min_temp","diff_max_temp","diff_range_temp","diff_mean_temp"))
    subdata$control <- data$point_name[controlid[as.numeric(id)]]
    
    write.csv(subdata,paste(workingdir,data$transectid[1],"_",id,"_wtemp_final_cleaned",".csv",sep=""))
    
    # Visualize
    files <- list.files(pattern = paste("watertemp_cleaned",".csv",sep=""))
    
    allcsv <- lapply(files,function(j){
      read.csv(j, header=TRUE)
    })
    
    allcsv_df <- do.call(rbind.data.frame, allcsv)
    
    allcsv_df=allcsv_df[!is.na(allcsv_df$point_name), ]
    
    ggplot(allcsv_df, aes(x=as.POSIXct(date), y=temp,color=point_name)) + geom_line(size=2) + theme_minimal() +
      scale_x_datetime(labels = date_format("%d/%H:%M"),date_breaks = "5 hours") +
      theme(axis.text.x = element_text(angle=45))+
      xlab("Date")+ylab("Water temperature [°C]")
    
    ggsave(paste(data$transectid[1],"wtemp.png",sep=""),width = 20, height = 10)
    
    }
  
}