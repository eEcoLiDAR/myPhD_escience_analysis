# Import required libraries
library("lidR")
library("RcppEigen")
library("Rcpp")

# Global variable
#full_path="D:/Paper1_ReedbedStructure/Data/ALS/Test/"
full_path="C:/zsofia/Amsterdam/Paper1/"

setwd(full_path) # working directory

#sourceCpp("D:\\GitHub\\eEcoLiDAR\\myPhD_escience_analysis\\R_process\\eigen.cpp")
sourceCpp("C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/myPhD_escience_analysis/R_process/eigen.cpp")

#set.seed(42)
#X <- matrix(rnorm(4*4), 4, 4)
#Z <- X %*% t(X)

las = readLAS("g32hz1rect2.las")

xyz=as.matrix(las@data[,1:3])
cov_m=cov(xyz)
eigen_m=eigen(cov_m)

eigen_m$values[1]

getEigenValues(cov_m)

ShapeMetrics = function(X,Y,Z)
{
  xyz=rbind(X,Y,Z) 
  cov_m=cov(xyz)
  eigen_m=eigen(cov_m)
  
  shapemetrics = list(
    eigen_largest = eigen_m$values[1],
    eigen_medium = eigen_m$values[2],
    eigen_smallest = eigen_m$values[3],
    curvature = eigen_m$values[1]/(eigen_m$values[1]+eigen_m$values[2]+eigen_m$values[3]),
    linearity = (eigen_m$values[1]-eigen_m$values[2])/eigen_m$values[1],
    planarity = (eigen_m$values[2]-eigen_m$values[3])/eigen_m$values[1],
    sphericity = eigen_m$values[3]/eigen_m$values[1],
    anisotrophy = (eigen_m$values[1]-eigen_m$values[3])/eigen_m$values[1]
  )
  return(shapemetrics)
}

shapemetrics = grid_metrics(las, ShapeMetrics(X,Y,Z),res=1)
plot(shapemetrics)

