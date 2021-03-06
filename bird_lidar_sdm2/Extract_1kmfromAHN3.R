"
@author: Zsofia Koma, UvA
Aim: Pre-process AHN2 data
"
library("lidR")
library("rgdal")

# Set working dirctory
workingdirectory="D:/Koma/Paper3/"
setwd(workingdirectory)

#Import csv
bykmsquare_wcoord_file="bird_data_sel_bykmsquare_wcoord.csv"
bykmsquare_wcoord=read.csv(file=bykmsquare_wcoord_file,header=TRUE,sep=",")

ctg = catalog(workingdirectory)

for (i in seq(from=14,to=nrow(bykmsquare_wcoord))){ 
  print(paste(workingdirectory,"C_",toupper(bykmsquare_wcoord$bladnr[i]),".LAZ",sep=""))
  
  subset = lasclipRectangle(ctg, bykmsquare_wcoord$X[i]-500, bykmsquare_wcoord$Y[i]-500, bykmsquare_wcoord$X[i]+500, bykmsquare_wcoord$Y[i]+500)
  
  if (subset@header@PHB[["Number of point records"]]>0) {
    writeLAS(subset,paste("C_",toupper(bykmsquare_wcoord$bladnr[i]),"_",i,".laz",sep=""))
  }
  
}