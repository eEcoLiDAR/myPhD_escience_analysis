"
@author: Zsofia Koma, UvA
Aim: Multilayer related feature caculation 
"

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