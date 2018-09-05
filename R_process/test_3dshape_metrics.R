# Import required libraries
library("lidR")
library("RcppEigen")
library("Rcpp")

full_path="C:/zsofia/Amsterdam/Paper1/"
setwd(full_path) # working directory

las = readLAS("g32hz1rect2.las")

xyz = las@data[,1:3]

sourceCpp("C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/myPhD_escience_analysis/R_process/eigen.cpp")

getEigenValues(xyz)

set.seed(42)
X <- matrix(rnorm(4*4), 4, 4)
Z <- xyz %*% t(xyz)

getEigenValues(Z)

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