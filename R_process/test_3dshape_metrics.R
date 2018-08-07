# Import required libraries
library("lidR")

full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testmetrics/"
setwd(full_path) # working directory

las = readLAS("tile_00003_norm.laz")

xyz = las@data[,1:3]
eigenvalues = eigen(cov(xyz))$values
print(eigenvalues)

Shape_VertDistr_Metrics = function(xyz)
{
  eigenvalue = eigen(cov(xyz))$values
  eigen_list = as.list(eigenvalue)
  return(eigen_list)
}

shapemetrics = grid_metrics3d(las, Shape_VertDistr_Metrics(las@data[,1:3]),res=1)
plot(shapemetrics)  