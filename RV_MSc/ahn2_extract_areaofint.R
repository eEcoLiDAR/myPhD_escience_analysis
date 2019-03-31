"
@author: Zsofia Koma, UvA
Aim: Extract area of interest from AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
#workingdirectory="D:/Reinier/"
workingdirectory="C:/Koma/Sync/_Amsterdam/08_coauthor_MScProjects/Reinier/datapreprocess/"
setwd(workingdirectory)

#Import csv
bytransect_wcoord=read.csv(file="boundaries_pertransects.csv",header=TRUE,sep=",")

ctg = catalog(workingdirectory)
#nrow(bytransect_wcoord

for (i in seq(from=15,to=17)){ 
  print(bytransect_wcoord$Transect[i])
  
  subset = lasclipRectangle(ctg, bytransect_wcoord$xmin[i]-1000, bytransect_wcoord$ymin[i]-1000, bytransect_wcoord$xmax[i]+1000, bytransect_wcoord$ymax[i]+1000)
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("Transect_",bytransect_wcoord$Transect[i],"_x_",round(bytransect_wcoord$xmin[i]-1000,digit=0),"_y_",round(bytransect_wcoord$ymin[i]-1000,digit=0),".laz",sep=""))
  }
  
}