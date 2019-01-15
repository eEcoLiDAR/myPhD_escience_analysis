"
@author: Zsofia Koma, UvA
Aim: Calculate LiDAR metrics (functions)
"

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepenrat = length(z[classification==2])/length(z),
    nofret_abovemean = length(z[z>mean(z)])/length(z)
  )
  return(coveragemetrics)
}

ShapeMetrics = function(X,Y,Z)
{
  xyz=rbind(X,Y,Z)
  xyz=as.matrix(xyz)
  eigen_m=rev(prcomp(xyz)[[1]])
  
  shapemetrics = list(
    eigen_largest = eigen_m[3],
    eigen_medium = eigen_m[2],
    eigen_smallest = eigen_m[1],
    curvature = eigen_m[1]/(eigen_m[3]+eigen_m[2]+eigen_m[1]),
    linearity = (eigen_m[3]-eigen_m[2])/eigen_m[3],
    planarity = (eigen_m[2]-eigen_m[1])/eigen_m[3],
    sphericity = eigen_m[1]/eigen_m[3],
    anisotrophy = (eigen_m[3]-eigen_m[1])/eigen_m[3]
  )
  return(shapemetrics)
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