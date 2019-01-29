"
@author: Zsofia Koma, UvA
Aim: Feature caculation functions (based on Tristan article)
"

CoverageMetrics = function(z,classification)
{
  
  z_norm=z-min(z)
  
  coveragemetrics = list(
    pulsepen_ground = (length(z[classification==2])/length(z))*100,
    totalvegvol = length(z[classification==1])/length(z[classification==2])*100,
    vegcover = (length(z[classification==1])/length(z))*100,
    cancov = (length(z[z>mean(z)])/length(z))*100,
    undcov = (length(z_norm[classification==1 & z_norm>0.5 & z_norm<2])),
    dens_perc_b2 = (length(z_norm[classification==1 & z_norm<2])/length(z_norm))*100,
    dens_perc_b2_5 = (length(z_norm[classification==1 & z_norm>2 & z_norm<5])/length(z_norm))*100
  )
  return(coveragemetrics)
}

HeightMetrics = function(z,classification)
{
  
  z_norm=z-min(z)
  
  heightmetrics = list(
    zmax = max(z_norm), 
    zmean = mean(z_norm),
    zmedian = median(z_norm),
    z025quantile = quantile(z_norm, 0.25),
    z075quantile = quantile(z_norm, 0.75),
    z090quantile = quantile(z_norm, 0.90),
    zcoeffvar = sd(z_norm)/mean(z_norm),
    zmean_undst = mean(z_norm[z_norm<5]),
    zmean_veg = mean(z_norm[classification==1]),
    zmedian_veg = median(z_norm[classification==1]),
    z025quantile_veg = quantile(z_norm[classification==1], 0.25),
    z075quantile_veg = quantile(z_norm[classification==1], 0.75),
    z090quantile_veg = quantile(z_norm[classification==1], 0.90),
    zcoeffvar_veg = sd(z_norm[classification==1])/mean(z_norm[classification==1]),
    zmean_undst_veg = mean(z_norm[classification==1 & z_norm<5])
  )
  return(heightmetrics)
}

ShapeMetrics = function(x,y,z)
{
  xyz=rbind(x,y,z) 
  cov_m=cov(xyz)
  eigen_m=eigen(cov_m)
  
  shapemetrics = list(
    curvature = eigen_m$values[3]/(eigen_m$values[1]+eigen_m$values[2]+eigen_m$values[3]),
    linearity = (eigen_m$values[1]-eigen_m$values[2])/eigen_m$values[1],
    planarity = (eigen_m$values[2]-eigen_m$values[3])/eigen_m$values[1],
    sphericity = eigen_m$values[3]/eigen_m$values[1],
    anisotrophy = (eigen_m$values[1]-eigen_m$values[3])/eigen_m$values[1]
  )
  return(shapemetrics)
}

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

VegStr_VertDistr_Metrics = function(z)
{
  library("e1071")
  
  z_norm=z-min(z)
  
  vertdistr_metrics = list(
    zstd = sd(z),
    zvar = var(z),
    zskew = skewness(z),
    zkurto = kurtosis(z),
    zentropy = entropy(z_norm, by = 0.5,zmax=NULL),
    canrelrat = (mean(z)-min(z))/max(z)-min(z),
    vertdenrat = (max(z)-median(z))/max(z),
    simpson = simpson(z_norm, by = 1, zmax = NULL),
    shannon = shannon(z_norm, by = 1, zmax = NULL)
  )
  return(vertdistr_metrics)
}