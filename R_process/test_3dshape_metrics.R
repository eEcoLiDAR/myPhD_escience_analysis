# Import required libraries
library("lidR")
library("factoextra")

full_path="D:/Paper1_ReedbedStructure/Data/ALS/Test/"
setwd(full_path) # working directory

las = readLAS("tile_00003.las")

xyz = las@data[,1:3]

res.pca <- prcomp(xyz,  scale = FALSE)
get_eig(res.pca)

eigenvalues = eigen(cov(xyz))$values
print(eigenvalues)

Shape_VertDistr_Metrics = function(xyz)
{
  res.pca <- prcomp(xyz,  scale = FALSE)
  eigenvalues = get_eig(res.pca)
  eigen_list = as.list(eigenvalues)
  return(eigen_list)
}

start_time <- Sys.time()

shapemetrics = grid_metrics(las, Shape_VertDistr_Metrics(las@data[,1:3]),res=5)

end_time <- Sys.time()
print(end_time - start_time)

plot(shapemetrics)

xyz = las@data[,1:3]
covar_m = cov(xyz)
eigenvalues=eigs(covar_m, k=3, opts = list(retvec = FALSE))

print(eigenvalues)