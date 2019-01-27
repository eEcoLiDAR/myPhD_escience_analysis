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
    undcov1 = (length(z_norm[classification==1 & z_norm<2])/length(z_norm))*100,
    undcov2 = (length(z_norm[classification==1 & z_norm>0.5 & z_norm<2])),
    undcov3 = (length(z_norm[classification==1 & z_norm>2 & z_norm<5]))
  )
  return(coveragemetrics)
}

HeightMetrics = function(z,classification)
{
  heightmetrics = list(
    zmax = max(z), 
    zmean = mean(z),
    zmedian = median(z),
    z025quantile = quantile(z, 0.25),
    z075quantile = quantile(z, 0.75),
    z090quantile = quantile(z, 0.90),
    zmean = mean(z[classification==1]),
    zmedian = median(z[classification==1]),
    z025quantile = quantile(z[classification==1], 0.25),
    z075quantile = quantile(z[classification==1], 0.75),
    z090quantile = quantile(z[classification==1], 0.90)
  )
  return(heightmetrics)
}