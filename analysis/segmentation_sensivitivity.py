import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('segment_1', help='polygon shape file with features and classes')
parser.add_argument('segment_2', help='polygon shape file with features and classes')
args = parser.parse_args()

# Import and define feature and label + test, train dataset

segment_1 = gpd.GeoDataFrame.from_file(args.path+args.segment_1)
segment_2 = gpd.GeoDataFrame.from_file(args.path+args.segment_2)

segment_1['Water']=segment_1['Open water']/segment_1['Sumfreq'].sum()
segment_1['Shrubs']=segment_1['Struweel']/segment_1['Sumfreq'].sum()
segment_1['Trees']=segment_1['Bos']/segment_1['Sumfreq'].sum()
segment_1['Grass']=segment_1['Grasland']/segment_1['Sumfreq'].sum()
segment_1['Reed poor']=segment_1['Landriet,']/segment_1['Sumfreq'].sum()
segment_1['Reed rich']=segment_1['Landriet_1']/segment_1['Sumfreq'].sum()
segment_1['Water reed']=segment_1['Waterriet']/segment_1['Sumfreq'].sum()

segment_1=segment_1[segment_1['Prob']>0.90]

segment_2['Water']=segment_2['Open water']/segment_2['Sumfreq'].sum()
segment_2['Shrubs']=segment_2['Struweel']/segment_2['Sumfreq'].sum()
segment_2['Trees']=segment_2['Bos']/segment_2['Sumfreq'].sum()
segment_2['Grass']=segment_2['Grasland']/segment_2['Sumfreq'].sum()
segment_2['Reed poor']=segment_2['Landriet,']/segment_2['Sumfreq'].sum()
segment_2['Reed rich']=segment_2['Landriet_1']/segment_2['Sumfreq'].sum()
segment_2['Water reed']=segment_2['Waterriet']/segment_2['Sumfreq'].sum()

segment_2=segment_2[segment_2['Prob']>0.90]

fig = plt.figure()
ax = fig.add_subplot(111)
segment_1[['Shrubs','Trees','Grass','Reed poor','Reed rich','Water reed']].sum().plot.bar(position=1,width = 0.1)
segment_2[['Shrubs','Trees','Grass','Reed poor','Reed rich','Water reed']].sum().plot.bar(position=3,width = 0.1)
plt.show()