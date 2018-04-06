"""
Aim: Explore the labeled dataset with pandas
"""

import sys
import argparse

import math
import numpy as np
import pandas as pd
import geopandas as gpd

import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('pcwfea', help='where the files are located')
args = parser.parse_args()

pc_wfea = pd.read_csv(args.path+args.pcwfea,sep=',')
print(pc_wfea.dtypes)

features=pc_wfea[['pulse_penetration_ratio','echo_ratio','Planarity','Sphericity','Curviture','kurto_z','skew_z','std_z','var_z','sigma_z','max_z','mean_z','median_z','range']]

# Extract correlation coefficients
"""
font = {'family': 'normal',
        'weight': 'bold',
        'size': 20}

plt.rc('font', **font)
fig=sns.heatmap(pc_wfea[['pulse_penetration_ratio','echo_ratio','Planarity','Sphericity','Curviture','kurto_z','skew_z','std_z','var_z','sigma_z','max_z','mean_z','median_z','range']].corr(), annot=True, fmt=".2f",xticklabels=1,yticklabels=1)
plt.setp(fig.xaxis.get_majorticklabels(), rotation=25, horizontalalignment='right')
plt.setp(fig.yaxis.get_majorticklabels(), rotation=25, horizontalalignment='right')
plt.show()
"""

# PCA analysis

z_scaler = StandardScaler()

fea_scaled = z_scaler.fit_transform(features)
pca_anal = PCA().fit(fea_scaled)
features_transf=pca_anal.transform(features) 

variance = pca_anal.explained_variance_ratio_.cumsum()

plt.plot(variance)
plt.ylabel('% Variance Explained')
plt.xlabel('# of Features')
plt.title('PCA Analysis')
plt.style.context('seaborn-whitegrid')
plt.show()

def pca_results(data, pca):
    
    # Dimension indexing
    dimensions = ['Dimension {}'.format(i) for i in range(1,len(pca.components_)+1)]
    
    # PCA components
    components = pd.DataFrame(np.round(pca.components_, 4), columns = ['pulse_penetration_ratio','echo_ratio','Planarity','Sphericity','Curviture','kurto_z','skew_z','std_z','var_z','sigma_z','max_z','mean_z','median_z','range']) 
    components.index = dimensions

    # PCA explained variance
    ratios = pca.explained_variance_ratio_.reshape(len(pca.components_), 1) 
    variance_ratios = pd.DataFrame(np.round(ratios, 4), columns = ['Explained Variance']) 
    variance_ratios.index = dimensions

    # Create a bar plot visualization
    fig, ax = plt.subplots(figsize = (14,8))

    # Plot the feature weights as a function of the components
    components.plot(ax = ax, kind = 'bar')
    ax.set_ylabel("Feature Weights") 
    ax.set_xticklabels(dimensions, rotation=0)

    # Display the explained variance ratios# 
    for i, ev in enumerate(pca.explained_variance_ratio_): 
        ax.text(i-0.40, ax.get_ylim()[1] + 0.05, "Explained Variance\n %.4f"%(ev))
    plt.show()

    # Return a concatenated DataFrame
    return pd.concat([variance_ratios, components], axis = 1)

pca_results = pca_results(fea_scaled, pca_anal)

print(pca_results.cumsum())

#Explained variance
plt.plot(pca_anal.explained_variance_ratio_)
plt.xlabel('number of components')
plt.ylabel('cumulative explained variance')
plt.show()