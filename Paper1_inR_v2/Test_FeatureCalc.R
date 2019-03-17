"
@author: Zsofia Koma, UvA
Aim: Test feature calc.
"

# Import required R packages
library("lidR")
library("rgdal")

# Set working directory
workingdirectory="C:/Koma/Paper1/ALS/"
setwd(workingdirectory)

cores=3
chunksize=500
buffer=2.5
resolution=2.5

rasterOptions(maxmemory = 200000000000)

# Set cataloges

ground_ctg <- catalog(paste(workingdirectory,"ground/",sep=""))

opt_chunk_buffer(ground_ctg) <- buffer
opt_chunk_size(ground_ctg) <- chunksize
opt_cores(ground_ctg) <- cores

# Feature calculation function
proportion_norm = function(z, by = 1)
{
  # Normalize
  
  z_norm=((z-min(z))/(max(z)-min(z)))*100
  
  # Define the number of x meters bins from 0 to 100%
  bk = seq(0, ceiling(100/by)*by, by)
  
  # Compute the p for each bin
  hist = hist(z_norm,bk,plot=TRUE)
  
  # Proportion
  p=(hist$counts/length(z_norm))
  
  return(p)
}

proportion_shift = function(z, by = 1)
{
  # Normalize
  
  z_norm=z-min(z)
  
  # Define the number of x meters bins from 0 to 100%
  bk = seq(0, ceiling(100/by)*by, by)
  
  # Compute the p for each bin
  hist = hist(z_norm,bk,plot=TRUE)
  
  # Proportion
  p=(hist$counts/length(z_norm))
  
  return(p)
}

VertDistr_Metrics = function(z)
{
  library("e1071")
  
  p=proportion_shift(z, by = 1)
  p_whnull=p[p>0]
  
  vertdistr_metrics = list(
    simpson = 1/sum(sqrt(p)),
    shannon = -sum(p_whnull*log(p_whnull))
  )
  return(vertdistr_metrics)
}

vertdistr_metrics = grid_metrics(ground_ctg, VertDistr_Metrics(Z),res=resolution)
plot(vertdistr_metrics)

# Horizontal metrics

max_z = grid_metrics(ground_ctg, max(Z),res=resolution)

start_time <- Sys.time()

sd_dsm=focal(max_z,w=matrix(1,3,3), fun=sd, pad=TRUE,na.rm = TRUE)

end_time <- Sys.time()
end_time - start_time

start_time <- Sys.time()
beginCluster(3)

sd_dsm <- clusterR(max_z, focal, args=list(w=matrix(1,3,3), fun=sd, pad=TRUE,na.rm = TRUE))

endCluster()
end_time <- Sys.time()
end_time - start_time

plot(sd_dsm)


