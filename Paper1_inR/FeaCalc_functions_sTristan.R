"
@author: Zsofia Koma, UvA
Aim: Feature caculation functions (based on Tristan article)
"

CoverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepen_ground = (length(z[classification==2])/length(z))*100,
    totalvegvol = length(z[classification==1])/length(z[classification==2]),
    vegcover = (length(z[classification==1])/length(z))*100,
    cancov1 = (length(z[z>mean(z)])/length(z))*100,
    cancov2 = (length(z[z>quantile(z, 0.25) & z<quantile(z, 0.75)])/length(z))*100,
    undcov1 = (length(z[classification==1 & z<2])/length(z))*100,
    undcov2 = (length(z[z>0.5 & z<2])),
    blow0 = (length(z[z<0]))
  )
  return(coveragemetrics)
}