"""
@author: Zsofia Koma, UvA
Aim: 

Input: 
Output: 

Example usage (from command line):   

ToDo: 
1. error bad lines (2114, 2333) why wrong

"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('vegdata', help='where the files are located')
args = parser.parse_args()

# Import data

dutchvegtable =pd.read_csv(args.path+args.vegdata+"_header.csv",sep='\t',error_bad_lines=False)
dutchvegtable_species =pd.read_csv(args.path+args.vegdata+"_species.csv",sep='\t',error_bad_lines=False)

#print(dutchvegtable.head())
#print(dutchvegtable_species.head())

# Introduce filters

min_year=2010
max_uncertainity=5

dutchvegtable_upyear=dutchvegtable[(dutchvegtable["Datum van opname"].str[-4:].astype('float64')>min_year)]
dutchvegtable_upyear=dutchvegtable_upyear[(dutchvegtable_upyear["Location uncertainty (m)"]<max_uncertainity)]

print(dutchvegtable_upyear.shape)

# Add species coverage info as one line

SpeciesGroups=dutchvegtable_species.groupby("PlotObservationID")["Species name"].apply(' '.join).reset_index()
LayerGroups=dutchvegtable_species.groupby("PlotObservationID")["Layer"].apply(lambda x: ', '.join(x.astype(str))).reset_index()
CoverGroups=dutchvegtable_species.groupby("PlotObservationID")["Cover %"].apply(lambda x: ', '.join(x.astype(str))).reset_index()
CoverCodeGroups=dutchvegtable_species.groupby("PlotObservationID")["Cover code"].apply(lambda x: ', '.join(x.astype(str))).reset_index()

JoinedTable=pd.merge(dutchvegtable_upyear,SpeciesGroups,on="PlotObservationID",how="left")
JoinedTable2=pd.merge(JoinedTable,LayerGroups,on="PlotObservationID",how="left")
JoinedTable3=pd.merge(JoinedTable2,CoverGroups,on="PlotObservationID",how="left")
JoinedTable4=pd.merge(JoinedTable3,CoverCodeGroups,on="PlotObservationID",how="left")

# Export

JoinedTable4.to_csv(args.path+args.vegdata+"observation_filtered.csv",sep=";",index=False)
