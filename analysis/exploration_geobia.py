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
pca_anal = PCA(n_components=2, svd_solver='full').fit(fea_scaled)
features_transf=pca_anal.transform(features) 

variance = pca_anal.explained_variance_ratio_.cumsum()
print(features_transf)

plt.plot(variance)
plt.ylabel('% Variance Explained')
plt.xlabel('# of Features')
plt.title('PCA Analysis')
plt.style.context('seaborn-whitegrid')
plt.show()


def get_important_features(transformed_features, components_, columns):
    """
    This function will return the most "important" 
    features so we can determine which have the most
    effect on multi-dimensional scaling
    """
    num_columns = len(columns)

    # Scale the principal components by the max value in
    # the transformed set belonging to that component
    xvector = components_[0] * max(transformed_features[:,0])
    yvector = components_[1] * max(transformed_features[:,1])

    # Sort each column by it's length. These are your *original*
    # columns, not the principal components.
    important_features = { columns[i] : math.sqrt(xvector[i]**2 + yvector[i]**2) for i in range(num_columns) }
    important_features = sorted(zip(important_features.values(), important_features.keys()), reverse=True)
    print("Features by importance:\n", important_features)

get_important_features(features_transf, pca_anal.components_, features.columns.values)

def draw_vectors(transformed_features, components_, columns):
    """
    This funtion will project your *original* features
    onto your principal component feature-space, so that you can
    visualize how "important" each one was in the
    multi-dimensional scaling
    """

    num_columns = len(columns)

    # Scale the principal components by the max value in
    # the transformed set belonging to that component
    xvector = components_[0] * max(transformed_features[:,0])
    yvector = components_[1] * max(transformed_features[:,1])

    ax = plt.axes()

    for i in range(num_columns):
    # Use an arrow to project each original feature as a
    # labeled vector on your principal component axes
        plt.arrow(0, 0, xvector[i], yvector[i], color='b', width=0.0005, head_width=0.02, alpha=0.75)
        plt.text(xvector[i]*1.2, yvector[i]*1.2, list(columns)[i], color='b', alpha=0.75)

    return ax
	
ax = draw_vectors(features_transf, pca_anal.components_, features.columns.values)
T_df = pd.DataFrame(features_transf)
T_df.columns = ['component1', 'component2']

T_df['color'] = 'y'
T_df.loc[T_df['component1'] > 125, 'color'] = 'g'
T_df.loc[T_df['component2'] > 125, 'color'] = 'r'

plt.xlabel('Principle Component 1')
plt.ylabel('Principle Component 2')
plt.scatter(T_df['component1'], T_df['component2'], color=T_df['color'], alpha=0.5)
plt.show()