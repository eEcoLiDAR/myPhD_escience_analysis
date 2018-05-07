"""
@author: Zsofia Koma, UvA
Aim: apply DT to classify segments

Input: 
Output: 

Example usage (from command line): python decisiontree_forsegments.py D:/Geobia_2018/Lauw_island_tiles/ tile_208000_598000_1_1.las.plywfea.shp vlakken_union_structuur.shp

ToDo: 

Comment:
segment_wlabel = gpd.GeoDataFrame( pd.concat( [segment_reed,segment_grass,segment_bushes,segment_openwater], ignore_index=True) )
"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd
from geopandas.tools import sjoin

from sklearn import tree
from sklearn.cross_validation import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score,precision_score,recall_score
from sklearn.metrics import classification_report

import matplotlib.pyplot as plt
import seaborn as sns

import graphviz 

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segments', help='polygon shape file with features and classes')
args = parser.parse_args()

segments = gpd.GeoDataFrame.from_file(args.path+args.segments)
print(segments.dtypes)

feature_list=np.array(['mean_echo_','mean_eigen','mean_max_z','mean_pulse','poly_area','mean_sigma','mean_skew_','mean_std_z'])

feature=segments[feature_list].values
label=segments['Highestid'].values

mytrain, mytest, mytrainlabel, mytestlabel = train_test_split(feature,label,train_size = 0.6)
target=['Grasland','Landriet, structuurrijk','Landriet, structuurarm','Open water','Struweel']

DT = tree.DecisionTreeClassifier(max_depth=5,class_weight="balanced")
DT_classifier = DT.fit(mytrain, mytrainlabel)

mypredtest=DT_classifier.predict(mytest)

print(classification_report(mytestlabel, mypredtest,target_names=target))
print(confusion_matrix(mytestlabel, mypredtest))

dot_data = tree.export_graphviz(DT_classifier, out_file=args.path+args.segments+".dotfile") 

mypred=DT_classifier.predict(feature)
print(mypred)

segments['pred_class']=mypred
#print(segments.head())

segments.to_file(args.path+args.segments+"_DTclass.shp", driver='ESRI Shapefile')

importances=DT_classifier.feature_importances_
indices = np.argsort(importances)[::-1]

for f in range(mytrain.shape[1]):
    print("%d. feature %s (%f)" % (f + 1, feature_list[indices[f]], importances[indices[f]]))

# Plot the feature importances of the forest
plt.figure()
plt.title("Feature importances")
plt.bar(range(mytrain.shape[1]), importances[indices],
       color="r", align="center")
plt.xticks(range(mytrain.shape[1]), feature_list[indices])
plt.xlim([-1, mytrain.shape[1]])
plt.show()
