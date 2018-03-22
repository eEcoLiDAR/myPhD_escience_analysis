"""
Aim: 
1. rasterize
2. rescale 3 features into an RGB composite
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
args = parser.parse_args()

pc_wfea = pd.read_csv(args.path+args.features,sep=' ',names=['X','Y','Z','coeff_var_z','density_absolute_mean','echo_ratio','gps_time','intensity','kurto_z','max_z','mean_z',
'median_z','min_z','perc_10','perc_100','perc_20','perc_30','perc_40','perc_50','perc_60','perc_70','perc_80','perc_90','pulse_penetration_ratio','range','raw_classification','sigma_z','skew_z','std_z','var_z'],skiprows=41)
#print(pc_wfea.dtypes)

# rescale on attribute into 0-255

# RED

attribute_R='sigma_z'

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

attribute_G='kurto_z'

min_orig_G=np.min(pc_wfea[attribute_G].values)
max_orig_G=np.max(pc_wfea[attribute_G].values)

min_wish_G=0
max_wish_G=255

k_G=(max_wish_G-min_wish_G)/(max_orig_G-min_orig_G)

Green_value=k_G*(pc_wfea[attribute_G].values-min_orig_G)+min_wish_G

# BLUE

attribute_B='range'

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

pc_wfea[['X','Y','Z','Red','Green','Blue']].to_csv(args.path+args.output,sep=';')