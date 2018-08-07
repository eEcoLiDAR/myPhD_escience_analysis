# Import required libraries
library("lidR")

library("rARPACK")

full_path="D:/Koma/Paper1_ReedStructure/Data/ALS/02gz2/testmetrics/"
setwd(full_path) # working directory

las = readLAS("tile_00003_norm.laz")

xyz = las@data[,1:3]
eigenvalues = eigen(cov(xyz))$values
print(eigenvalues)

Shape_VertDistr_Metrics = function(xyz)
{
  covar_m = cov(xyz)
  eigenvalues=eigs(covar_m, k=3, opts = list(retvec = FALSE))
  eigen_list = as.list(eigenvalues$values)
  return(eigen_list)
}

start_time <- Sys.time()

shapemetrics = grid_metrics(las, Shape_VertDistr_Metrics(las@data[,1:3]),res=1)

end_time <- Sys.time()
print(end_time - start_time)

plot(shapemetrics)

xyz = las@data[,1:3]
covar_m = cov(xyz)
eigenvalues=eigs(covar_m, k=3, opts = list(retvec = FALSE))

print(eigenvalues)