"
@author: Zsofia Koma, UvA
Aim: process wetland OTKA project data step 2.: organize a master file which will controll the analysis of the concrete sensor data 
"

library(readxl)
library(data.table)
library(rgdal)

workingdir="D:/Sync/_Amsterdam/11_AndrasProject/balaton/"
locations=c("fuzfo","mariafurdo","sajkod","szantod","szigliget")

# Organize water tempreture data

for (filename in locations) {
  print(filename)
  
  setwd(paste(workingdir,"/",filename,"/",sep=""))
  
  filelist=list.files(pattern="xls$")
  filelistcoord=list.files(pattern="*formaster.csv")
  
  date=read.csv(paste(filename,".dat",sep=""),sep = ",",header = FALSE)
  
  for (j in filelistcoord) {
    coord=read.csv(j)
    
    sensorid=sub("_.*", "", filelist)
    
    headerdata <- data.frame(matrix(unlist(filelist), nrow=length(filelist), byrow=T),stringsAsFactors=FALSE)
    names(headerdata)<- c("hobo")
    
    headerdata$dir<-workingdir
    headerdata$transectid<-filename
    headerdata$water_temp <- as.numeric(sensorid)
    
    headerdata$startdate <- as.POSIXct(as.character(date$V1),format="%Y-%m-%d %H:%M",tz=Sys.timezone())
    headerdata$enddate <- as.POSIXct(as.character(date$V2),format="%Y-%m-%d %H:%M",tz=Sys.timezone())
    
    headerdata_wcoord=merge(x = headerdata, y = coord, by = c("water_temp"), all.x = TRUE)
    
    id=sub("_.*", "", j)
    
    write.csv(headerdata_wcoord,paste(id,"_",headerdata$transectid[1],"_masterfile_watertemp.csv",sep=""))
    
  }
    
}

# Organize Humidity and tempreture 

for (filename in locations) {
  print(filename)
  
  setwd(paste(workingdir,"/",filename,"/",sep=""))
  
  filelist=list.files(pattern="txt$")
  filelistcoord=list.files(pattern="*formaster.csv")
  
  date=read.csv(paste(filename,".dat",sep=""),sep = ",",header = FALSE)
  
  for (j in filelistcoord) {
    coord=read.csv(j)
    
    sensorid=sub("_.*", "", filelist)
    
    headerdata <- data.frame(matrix(unlist(filelist), nrow=length(filelist), byrow=T),stringsAsFactors=FALSE)
    names(headerdata)<- c("easylog")
    
    headerdata$dir<-workingdir
    headerdata$transectid<-filename
    headerdata$humidity_s <- as.numeric(sensorid)
    
    headerdata$startdate <- as.POSIXct(as.character(date$V1),format="%Y-%m-%d %H:%M",tz=Sys.timezone())
    headerdata$enddate <- as.POSIXct(as.character(date$V2),format="%Y-%m-%d %H:%M",tz=Sys.timezone())
    
    headerdata_wcoord=merge(x = headerdata, y = coord, by = c("humidity_s"), all.x = TRUE)
    
    id=sub("_.*", "", j)
    
    write.csv(headerdata_wcoord,paste(id,"_",headerdata$transectid[1],"_masterfile_humid.csv",sep=""))
    
  }
  
}