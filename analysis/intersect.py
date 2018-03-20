"""
Aim: 
1. Read shapefile (training)
2. Extract point cloud related to the polygons
3. Add class label to the extracted point cloud
4. Save as a pandas dataframe (csv)
"""
import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

from shapely.geometry import Point
from geopandas.tools import sjoin

import matplotlib.pyplot as plt
import seaborn as sns

parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('training', help='polygon shape file with class')
parser.add_argument('features', help='point cloud with features')
args = parser.parse_args()

crs = {'init': 'epsg:28992'}

training = gpd.GeoDataFrame.from_file(args.path+args.training,crs=crs)

pc_wfea = pd.read_csv(args.path+args.features,sep=';')
pc_wfea['geometry'] = pc_wfea.apply(lambda z: Point(z.X, z.Y), axis=1)
pc_wfea = gpd.GeoDataFrame(pc_wfea,crs=crs)

pointInPolys = sjoin(pc_wfea , training, how='left',op='within')

pointInPolys_sel=pointInPolys.dropna(axis=0, how='any')

pointInPolys_sel.to_csv(args.path+args.features+'_sel.csv')




