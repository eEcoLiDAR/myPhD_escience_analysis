"""
@author: Zsofia Koma, UvA
Aim: 

Input: laserchicken ply file with the calculated features (currently I am only using z), 3 features which we would like to use for colorization 
Output: XYZRGB ascii

Example usage (from command line):  python RGB.py C:/zsofia/Amsterdam/Geobia/Features/ tile_207500_598000_1_1.las.ply tile_207500_598000_1_1 echo_ratio e
igenv_1 sigma_z

ToDo: 

"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('features', help='point cloud with features')
parser.add_argument('output', help='name of output')
parser.add_argument('Red', help='Red')
parser.add_argument('Green', help='Green')
parser.add_argument('Blue', help='Blue')
args = parser.parse_args()

pc_wfea =pd.read_csv(args.path+args.features,sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','eigenv_1','eigenv_2','eigenv_3','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','normal_vector_1','normal_vector_2','normal_vector_3','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','slope','std_z','var_z'],skiprows=39)
#print(pc_wfea.dtypes)

# rescale on attribute into 0-255

# RED

attribute_R=args.Red

min_orig_R=np.min(pc_wfea[attribute_R].values)
max_orig_R=np.max(pc_wfea[attribute_R].values)

min_wish_R=0
max_wish_R=255

k_R=(max_wish_R-min_wish_R)/(max_orig_R-min_orig_R)

Red_value=k_R*(pc_wfea[attribute_R].values-min_orig_R)+min_wish_R

"""
plt.hist(pc_wfea[attribute_R].values, 20, facecolor='red', alpha=0.5)
plt.show()

plt.hist(Red_value, 20, facecolor='red', alpha=0.5)
plt.show()
"""

# GREEN

attribute_G=args.Green

min_orig_G=np.min(pc_wfea[attribute_G].values)
max_orig_G=np.max(pc_wfea[attribute_G].values)

min_wish_G=0
max_wish_G=255

k_G=(max_wish_G-min_wish_G)/(max_orig_G-min_orig_G)

Green_value=k_G*(pc_wfea[attribute_G].values-min_orig_G)+min_wish_G

# BLUE

attribute_B=args.Blue

min_orig_B=np.min(pc_wfea[attribute_B].values)
max_orig_B=np.max(pc_wfea[attribute_B].values)

min_wish_B=0
max_wish_B=255

k_B=(max_wish_B-min_wish_B)/(max_orig_B-min_orig_B)

Blue_value=k_B*(pc_wfea[attribute_B].values-min_orig_B)+min_wish_B

# Export

pc_wfea['Red']=Red_value
pc_wfea['Green']=Green_value
pc_wfea['Blue']=Blue_value

pc_wfea[['X','Y','Z','Red','Green','Blue']].to_csv(args.path+args.output+str(attribute_R)+str(attribute_G)+str(attribute_B)+'.csv',sep=';')