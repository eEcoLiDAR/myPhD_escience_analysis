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
parser.add_argument('segments', help='polygon shape file with class')
parser.add_argument('training', help='polygon')
args = parser.parse_args()

segments = gpd.GeoDataFrame.from_file(args.path+args.segments)
#print(segments.head())

training = gpd.GeoDataFrame.from_file(args.path+args.training)
#print(training.head())

segment_wlabel = gpd.sjoin(segments, training, how="inner", op='within')
segment_wlabel.to_file(args.path+args.segments+"wfealabel.shp", driver='ESRI Shapefile')

feature=segment_wlabel[['echo_ratio','max_z','kurto_z','pulse_pene']].values
label=segment_wlabel['structyp_e'].values

mytrain, mytest, mytrainlabel, mytestlabel = train_test_split(feature,label,train_size = 0.6)
target=['Grasland','Landriet, structuurrijk','Open water','Struweel']

DT = tree.DecisionTreeClassifier(max_depth=5,class_weight="balanced")
DT_classifier = DT.fit(mytrain, mytrainlabel)

mypredtest=DT_classifier.predict(mytest)

print(classification_report(mytestlabel, mypredtest,target_names=target))
print(confusion_matrix(mytestlabel, mypredtest))

dot_data = tree.export_graphviz(DT_classifier, out_file=args.path+args.segments+".dotfile") 


