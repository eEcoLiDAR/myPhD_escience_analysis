library(lidR)

CoverageMetrics = function(z,classification) {
  coveragemetrics = list(
    pulsepenrat = length(z[classification==2])/length(z),
    nofret_abovemean = length(z[z>mean(z)])/length(z)
  )
  return(coveragemetrics)
}

VegStr_VertDistr_Metrics = function(z)
{
  library("e1071")
  vertdistr_metrics = list(
    zstd = sd(z),
    zvar = var(z),
    zskew = skewness(z),
    zkurto = kurtosis(z),
    zentropy1=VCI(z,by=0.5,zmax=NULL),
    zentropy2=entropy(z+500, by = 0.5,zmax=NULL)
  )
  return(vertdistr_metrics)
}

HeightMetrics = function(z)
{
  heightmetrics = list(
    zmax = max(z), 
    zmean = mean(z),
    zmedian = median(z),
    z025quantile = quantile(z, 0.25),
    z075quantile = quantile(z, 0.75),
    z090quantile = quantile(z, 0.90)
  )
  return(heightmetrics)
}

ShapeMetrics = function(X,Y,Z)
{
  xyz=rbind(X,Y,Z) 
  cov_m=cov(xyz)
  eigen_m=eigen(cov_m)
  
  shapemetrics = list(
    eigen_largest = eigen_m$values[1],
    eigen_medium = eigen_m$values[2],
    eigen_smallest = eigen_m$values[3],
    curvature = eigen_m$values[3]/(eigen_m$values[1]+eigen_m$values[2]+eigen_m$values[3]),
    linearity = (eigen_m$values[1]-eigen_m$values[2])/eigen_m$values[1],
    planarity = (eigen_m$values[2]-eigen_m$values[3])/eigen_m$values[1],
    sphericity = eigen_m$values[3]/eigen_m$values[1],
    anisotrophy = (eigen_m$values[1]-eigen_m$values[3])/eigen_m$values[1]
  )
  return(shapemetrics)
}



# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/lidR_error/"
setwd(workingdirectory)

ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 1
opt_chunk_size(ctg) <- 500
opt_cores(ctg) <- 18

metrics = grid_metrics(ctg, c(CoverageMetrics(Z,Classification), VegStr_VertDistr_Metrics(Z), HeightMetrics(Z), ShapeMetrics(X,Y,Z)), res = 2.5)
plot(metrics)