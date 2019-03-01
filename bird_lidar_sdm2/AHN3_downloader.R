"
@author: Zsofia Koma, UvA
Aim: This script download the required AHN3 data from the pdok website
"

# Set working directory
workingdirectory="C:/Koma/Paper3/ALS/" ## set this directory where you would like to put your las files
setwd(workingdirectory)

# Import filenames file
ahn3file="listahn3.csv"
ahn3list=read.csv(file=ahn3file,header=TRUE,sep=",")

# Set filenames and dwnload and unzip the required dataset
req_tile=ahn3list$bladnr_up[1:2]

for (tile in req_tile){
  print(tile[1])
  
  download.file(paste("https://geodata.nationaalgeoregister.nl/ahn3/extract/ahn3_laz/C_",tile,".LAZ",sep=""),
                paste("C_",tile,".LAZ",sep=""))
}

