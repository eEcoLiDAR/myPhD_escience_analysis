"
@author: Zsofia Koma, UvA
Aim: Organizing the Dutch vegetation database for reedbed delinaition
  
Input: 
Output: 

Function:
1. Import Dutch vegetation database
2. Filter out based on year and maximum coordinate uncertainity
3. Points convert into polygon based on recorded length and width
4. Export as polygon for GEE
  
Example usage (from command line):   
  
ToDo: 
"

# call the required libraries
library("stringr")

# set global variables
setwd("D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/test_data") # working directory

min_year=2010

# import data
VegDB_header=read.csv(file="Swamp_communities_header.csv",header=TRUE,sep="\t")

# introduce filters
VegDB_header$year=as.numeric(str_sub(VegDB_header$Datum.van.opname,-4,-1)) # define a numeric year attribute

VegDB_header_filtered=VegDB_header[ which(VegDB_header$year>2012),]
