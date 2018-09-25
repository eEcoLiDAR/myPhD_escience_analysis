"
@author: Zsofia Koma, UvA

Aim: pre-process LiDAR data

input: downloaded laz file
output: ground-vegetation laz file

Fuctions:


Example: 

"

library("lidR")
library("rlas")

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepenrat = length(z[classification==2])/length(z)
  )
  return(coveragemetrics)
}

# Global variable
full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testiled2/"
setwd(full_path) # working directory

file.names <- dir(full_path, pattern =".laz")
for(i in 1:length(file.names)){
  
  start_time <- Sys.time()
  
  print(paste(full_path,file.names[i],sep=""))
  writelax(paste(full_path,file.names[i],sep=""))
  
  las = readLAS(file.names[i])
  
  pulsepen = grid_metrics(las, CoverageMetrics(Z,Classification),res=2.5)
  #plot(pulsepen)

}