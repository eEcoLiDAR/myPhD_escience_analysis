"""
@author: Zsofia Koma, UvA
Aim: transform ply into xyz ascii file for further analysis and process

Input: ply with extracted features from laserchicken
Output: txt with header and xyz + extra attributes

Example usage (from command line): python ply_tograss.py C:/zsofia/Amsterdam/Geobia/Features/ tile_208000_598000_1_1.las.ply tile_208000_598000_1_1.las.txt

ToDo: 
1. how to get coloumn names automatically?
2. delete where all coloumn value is nan or one value (-999)
"""

import sys
import argparse

import numpy as np
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('features', help='point cloud with features')
parser.add_argument('output', help='name of output')
args = parser.parse_args()

# Read ply into pandas dataframe 
pc_wfea = pd.read_csv(args.path+args.features,sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','eigenv_1','eigenv_2','eigenv_3','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','normal_vector_1','normal_vector_2','normal_vector_3','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','slope','std_z','var_z'],skiprows=39)
#print(pc_wfea.dtypes)
print(pc_wfea.head())

# Delete coloumns where all value is 0  
pc_wfea = pc_wfea.loc[:, (pc_wfea != 0).any(axis=0)]

# Export pandas dataframe 
pc_wfea.to_csv(args.path+args.output,sep=';',index=False)

