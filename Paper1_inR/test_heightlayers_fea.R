"
@author: Zsofia Koma, UvA
Aim: Feature caculation AHN2 data
"
library("lidR")
library("rgdal")
#source("C:/Koma/Github/komazsofi/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")
source("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/Paper1_inR/FeaCalc_functions_sTristan.R")

# Set working dirctory
workingdirectory="D:/Koma/Paper1/ALS/"
setwd(workingdirectory)

resolution=2.5
core=2

# Set cataloge

gr_hom_ctg <- catalog(paste(workingdirectory,"homogenized/",sep=""))

simpson = function(z, by = 1, zmax = NULL)
{
  # Fixed entropy (van Ewijk et al. (2011)) or flexible entropy
  if (is.null(zmax))
    zmax = max(z)
  
  # If zmax < 3 it is meaningless to compute entropy
  if (zmax < 2 * by)
    return(NA_real_)
  
  if (min(z) < 0)
    return(NA_real_)
  
  # Define the number of x meters bins from 0 to zmax (rounded to the next integer)
  bk = seq(0, ceiling(zmax/by)*by, by)
  
  # Compute the p for each bin
  hist = hist(z,bk,plot=FALSE)
  
  # Proportion
  p=(hist$counts/length(z))
  
  # Simpson index
  D=1/sum(sqrt(p))
  
  return(D)
}

z = abs(rnorm(50, 25, 1))
simpson = simpson(z, by = 1, zmax = NULL)
simpson

shannon = function(z, by = 1, zmax = NULL)
{
  # Fixed entropy (van Ewijk et al. (2011)) or flexible entropy
  if (is.null(zmax))
    zmax = max(z)
  
  # If zmax < 3 it is meaningless to compute entropy
  if (zmax < 2 * by)
    return(NA_real_)
  
  if (min(z) < 0)
    return(NA_real_)
  
  # Define the number of x meters bins from 0 to zmax (rounded to the next integer)
  bk = seq(0, ceiling(zmax/by)*by, by)
  
  # Compute the p for each bin
  hist = hist(z,bk,plot=FALSE)
  
  # Proportion
  p=(hist$counts/length(z))
  p=p[p>0]
  
  # Simpson index
  S=-sum(p*log(p))
  
  return(S)
}

z = abs(rnorm(50, 25, 1))
shannon = shannon(z, by = 1, zmax = NULL)
shannon