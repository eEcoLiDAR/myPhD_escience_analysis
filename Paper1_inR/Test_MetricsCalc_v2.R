library(lidR)

ShapeMetrics = function(X,Y,Z)
{
  th=Z[Z>quantile(Z, 0.25)]
  xyz=rbind(X,Y,Z) 
  cov_m=cov(xyz[Z>th])
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

VegStr_VertDistr_Metrics = function(z)
{
  library("e1071")
  vertdistr_metrics = list(
    zstd = sd(z[z>quantile(z, 0.25)]),
    zvar = var(z[z>quantile(z, 0.25)]),
    zskew = skewness(z[z>quantile(z, 0.25)]),
    zkurto = kurtosis(z[z>quantile(z, 0.25)]),
    zentropy2=entropy(z[z>quantile(z, 0.25)]+500, by = 0.5,zmax=NULL)
  )
  return(vertdistr_metrics)
}

HeightMetrics = function(z)
{
  heightmetrics = list(
    zmax = max(z[z>quantile(z, 0.25)]), 
    zmean = mean(z[z>quantile(z, 0.25)]),
    zmedian = median(z[z>quantile(z, 0.25)]),
    z025quantile = quantile(z[z>quantile(z, 0.25)], 0.25),
    z075quantile = quantile(z[z>quantile(z, 0.25)], 0.75),
    z090quantile = quantile(z[z>quantile(z, 0.25)], 0.90)
  )
  return(heightmetrics)
}

workingdirectory="D:/Koma/Paper1/ALS/lidR_error/"
setwd(workingdirectory)

ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 1
opt_chunk_size(ctg) <- 500
opt_cores(ctg) <- 18

metrics = grid_metrics(ctg, ShapeMetrics(X,Y,Z), res = 2.5)
plot(metrics)