library(readxl)
library(data.table)
library(rgdal)

workingdir="D:/Sync/_Amsterdam/11_AndrasProject/tisza/2017_poroszlo/"
setwd(workingdir)

# Organize hobo data
filelist=list.files(pattern="xls$")
coord=read.csv(list.files(pattern="*formaster.csv"))

sensorid=sub("_.*", "", filelist)

headerdata <- data.frame(matrix(unlist(filelist), nrow=length(filelist), byrow=T),stringsAsFactors=FALSE)
names(headerdata)<- c("hobo")

headerdata$dir<-workingdir
headerdata$transectid<-"2017_poroszlo"
headerdata$water_temp <- as.numeric(sensorid)

for (i in seq(1,length(filelist))) {
  print(i)
  
  data <- read_excel(paste(workingdir,headerdata[i,1],sep=""),sheet = 1,skip=1)
  names(data)<-c('nofmes','date','temp','none')
  df <- subset(data, select = c('nofmes','date','temp'))
  
  x = format(as.Date(df$date, "%m/%d/%y"), "%Y%m%d")
  x2 = format(as.POSIXct(df$date,format="%m/%d/%y %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
  
  headerdata$date[[i]] <- x[1]
  
  headerdata$startdate[[i]] <- x2[1]
  headerdata$enddate[[i]] <- x2[length(x2)]
  
}

headerdata_wcoord=merge(x = headerdata, y = coord, by = c("water_temp"), all.x = TRUE)

headerdata_wcoord$startdate <- as.POSIXct("2017-06-28 17:38:00",format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())
headerdata_wcoord$enddate <- as.POSIXct("2017-06-29 12:17:00",format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())

write.csv(headerdata_wcoord,paste(headerdata$transectid[1],"_masterfile.csv",sep=""))
