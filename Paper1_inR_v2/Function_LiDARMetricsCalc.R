"
@author: Zsofia Koma, UvA
Aim: Feature caculation functions (based on Tristan article)
"

eigenmetrics = function(X,Y,Z)
{
  xyz=cbind(X,Y,Z) 
  cov_m=cov(xyz) 
  
  if(sum(is.na(cov_m))==0) {
    
    eigen_m=eigen(cov_m)
    
    shapemetrics = list(
      curvature = eigen_m$values[3]/(eigen_m$values[1]+eigen_m$values[2]+eigen_m$values[3]),
      linearity = (eigen_m$values[1]-eigen_m$values[2])/eigen_m$values[1],
      planarity = (eigen_m$values[2]-eigen_m$values[3])/eigen_m$values[1],
      sphericity = eigen_m$values[3]/eigen_m$values[1]
    )
    return(shapemetrics)
  }
}

coverageMetrics = function(z,classification)
{
  coveragemetrics = list(
    pulsepen_ground = (length(z[classification==2])/length(z))*100,
    cancov = (length(z[z>mean(z)])/length(z))*100,
    dens_perc_b2 = (length(z[classification==1 & z<2])/length(z))*100,
    dens_perc_b2_5 = (length(z[classification==1 & z>2 & z<5])/length(z))*100
  )
  return(coveragemetrics)
}