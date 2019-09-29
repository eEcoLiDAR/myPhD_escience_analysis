library(readxl)
library(data.table)
library(rgdal)

workingdir="C:/Koma/Sync/_Amsterdam/11_AndrasProject/FieldData/"
setwd(workingdir)

# Separate shapefile
shp=readOGR(".","tisza")
shp.df <- as(shp, "data.frame")

shp.df_split <- split(shp.df, shp.df$X5_pole_con)

allNames <- names(shp.df_split)
for(thisName in allNames){
  write.csv(shp.df_split[[thisName]],paste(thisName,".csv",sep=""))
}

# Working with hobo data
dirlist=list.dirs(path = workingdir, full.names = FALSE, recursive = FALSE)
filelist=list.files(path=paste(workingdir,dirlist[1],"/",sep=""),pattern="xls$")

sensorid=sub("_.*", "", filelist)

headerdata <- data.frame(matrix(unlist(filelist), nrow=21, byrow=T),stringsAsFactors=FALSE)
names(headerdata)<- c("hobo")

headerdata$dir<-dirlist[1]
headerdata$water_temp <- as.numeric(sensorid)

for (i in seq(1,21)) {
  print(i)
  
  data <- read_excel(paste(workingdir,dirlist[1],"/",headerdata[i,1],sep=""),sheet = 1,skip=1)
  names(data)<-c('nofmes','date','temp','none')
  df <- subset(data, select = c('nofmes','date','temp'))
  
  x = format(as.Date(df$date, "%m/%d/%y"), "%Y%m%d")
  x2 = format(as.POSIXct(df$date,format="%m/%d/%y %H:%M:%S",tz=Sys.timezone()), "%Y-%m-%d %H:%M:%S")
  
  print(x[1])
  
  headerdata$date[[i]] <- x[1]
  
  headerdata$startdate[[i]] <- x2[1]
  headerdata$enddate[[i]] <- x2[length(x2)]
  
}

# Get coordinates
csvlist=list.files(path=paste(workingdir,dirlist[1],"/",sep=""),pattern="csv$")
coord=read.csv(paste(workingdir,dirlist[1],"/",csvlist,sep=""))

headerdata_wcoord=merge(x = headerdata, y = coord, by = c("water_temp"), all.x = TRUE)

# Determine control groups
controlid=grep("control", headerdata_wcoord$point_name)

for (g in seq(1,length(controlid))) {
  print(g)
  
  headerdata_wcoord$distcont <- sqrt((headerdata_wcoord$coords.x1[controlid[g]]-headerdata_wcoord$coords.x1)^2+(headerdata_wcoord$coords.x2[controlid[g]]-headerdata_wcoord$coords.x2)^2)
  control=headerdata_wcoord[which(headerdata_wcoord$distcont<100),]
  
  write.csv(control,paste(g,"_",control$dir[1],".csv",sep=""))
}

