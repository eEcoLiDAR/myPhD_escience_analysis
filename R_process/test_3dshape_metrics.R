# Import required libraries
library("lidR")
library("RcppEigen")
library("Rcpp")

# Global variable
full_path="D:/Paper1_ReedbedStructure/Data/ALS/Test/"
setwd(full_path) # working directory


sourceCpp("D:\\GitHub\\eEcoLiDAR\\myPhD_escience_analysis\\R_process\\eigen.cpp")

set.seed(42)
X <- matrix(rnorm(4*4), 4, 4)
Z <- X %*% t(X)

getEigenValues(Z)

