"
@author: Zsofia Koma, UvA
Aim: explore training-validation data
"

# Import libraries
library("sp")
library("rgdal")
library("raster")
library("spatialEco")
library("rgeos")
library("plyr")
library("dplyr")
library("maptools")
library("gridExtra")

library("ggplot2")
library("ggmap")
library("maps")
library("mapdata")
library('lattice')

# Set global variables
#full_path="D:/Sync/_Amsterdam/02_Paper1_ReedbedStructure_onlyALS/3_Dataprocessing/forClassification/"
#full_path="D:/Koma/Paper1/ALS/forClassification2/"
full_path="D:/Koma/Paper1_ReedStructure/preliminarly/Result_run1/"

filename="featuretable_level1_b2o5.csv"
#filename="featuretable_level2_b2o5.csv"
#filename="featuretable_level3_b2o5.csv"

setwd(full_path)

pdf("boxplot_level1.pdf") 

# Import
featuretable=read.csv(filename)

colnames=names(featuretable)

# Boxplots

for (i in 1:22){
  print(colnames[i])
  
  #jpeg(paste(substr(filename, 1, nchar(filename)-4),colnames[i],'_boxplot.jpg',sep=''))
  boxplot(featuretable[[colnames[i]]]~layer,data=featuretable,ylab=colnames[i])
  #dev.off()
}

for (i in 1:22){
  print(colnames[i])
  p=ggplot(featuretable,aes(x=featuretable[,i]))+geom_histogram()+facet_grid(~layer)+theme_bw()+ggtitle(colnames[i])
  print(p)
}

dev.off()