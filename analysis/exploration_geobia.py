"""
Aim: Explore the labeled dataset with pandas
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
parser.add_argument('pcwfea', help='where the files are located')
args = parser.parse_args()

pc_wfea = pd.read_csv(args.path+args.pcwfea,sep=',')
print(pc_wfea.dtypes)

# Extract correlation coeffitients

font = {'family': 'normal',
        'weight': 'bold',
        'size': 20}

plt.rc('font', **font)
fig=sns.heatmap(pc_wfea[['pulse_penetration_ratio','echo_ratio','Planarity','Sphericity','Curviture','kurto_z','skew_z','std_z','var_z','sigma_z','max_z','mean_z','median_z','range']].corr(), annot=True, fmt=".2f",xticklabels=1,yticklabels=1)
plt.setp(fig.xaxis.get_majorticklabels(), rotation=25, horizontalalignment='right')
plt.setp(fig.yaxis.get_majorticklabels(), rotation=25, horizontalalignment='right')
plt.show()
