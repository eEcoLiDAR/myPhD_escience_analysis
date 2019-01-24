library(lidR)

CoverageMetrics = function(z,classification) {
  coveragemetrics = list(
    nofret_abovemean = length(z[z>mean(z)])/length(z)
  )
  return(coveragemetrics)
}

VegStr_VertDistr_Metrics = function(z)
{
  library("e1071")
  vertdistr_metrics = list(
    zskew = skewness(z),
    zkurto = kurtosis(z),
    zentropy2=entropy(z+500, by = 0.5,zmax=NULL)
  )
  return(vertdistr_metrics)
}

HeightMetrics = function(z)
{
  heightmetrics = list(
    zmax = max(z)
  )
  return(heightmetrics)
}

ShapeMetrics = function(X,Y,Z)
{
  xyz=rbind(X,Y,Z) 
  cov_m=cov(xyz)
  eigen_m=eigen(cov_m)
  
  shapemetrics = list(
    eigen_largest = eigen_m$values[1]
  )
  return(shapemetrics)
}

grid_metrics2 = function(las, func, res = 20, start = c(0,0), filter = NULL)
{
  alignment <- list(res = res, start = start)
  lidR::opt_chunk_buffer(las) <- 0.1*alignment$res
  
  is_formula <- tryCatch(lazyeval::is_formula(func), error = function(e) FALSE)
  if (!is_formula) func <- lazyeval::f_capture(func)
  glob <- future::getGlobalsAndPackages(func)
  
  options <- list(need_buffer = FALSE, drop_null = TRUE, globals = names(glob$globals), raster_alignment = alignment)
  output  <- lidR::catalog_apply(las, grid_metrics, func = func, res = res, start = start,.options = options)
  return(output)
}


# Set working dirctory
#workingdirectory="C:/Koma/Paper1/ALS/"
workingdirectory="D:/Koma/Paper1/ALS/lidR_error/"
setwd(workingdirectory)

ctg <- catalog(workingdirectory)

opt_chunk_buffer(ctg) <- 1
opt_chunk_size(ctg) <- 500
opt_cores(ctg) <- 18

metrics = grid_metrics(ctg,  c(CoverageMetrics(Z,Classification), VegStr_VertDistr_Metrics(Z), HeightMetrics(Z), ShapeMetrics(X,Y,Z)), res = 2.5)
plot(metrics)

#writeRaster(metrics,"metrics.grd",overwrite=TRUE)

#list_metrics = grid_metrics2(ctg, c(CoverageMetrics(Z,Classification), VegStr_VertDistr_Metrics(Z), HeightMetrics(Z), ShapeMetrics(X,Y,Z)), res = 2.5)
#r = lidR:::merge_rasters(list_metrics)

#list_metrics = grid_metrics2(ctg, VegStr_VertDistr_Metrics(Z), res = 10)
#r = lidR:::merge_rasters(list_metrics)