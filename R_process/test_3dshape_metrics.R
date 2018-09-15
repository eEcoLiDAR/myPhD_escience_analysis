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
len = length(las@data$X)

xyz=as.matrix(las@data[2:4,1:3])
xyz_t <- xyz %*% t(xyz)

getEigenValues(xyz_t)

eigen(xyz_t)

