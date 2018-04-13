"""
@author: Zsofia Koma, UvA
Aim: assign the validation data to the segmentation results

Input: validation data (digitized shapefile) and segmentation results saved as point shape file
Output: point shape file with class label

Example usage (from command line):   python assignclassvalues.py D:/Geobia_2018/Lauw_island_tiles/ vlakken_union_structuur test2points

ToDo: 
1. highest score in the case of big segment not always representative 

"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

from shapely.geometry import Point, Polygon
from geopandas.tools import sjoin


parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('validation', help='name of polygon')
parser.add_argument('segments', help='name of the shp file with segmentID (points)')
args = parser.parse_args()

# read the validation polygon and segmentation results (point shape file)

print("------ Import data------ ")

crs = {'init': 'epsg:28992'}

validation = gpd.GeoDataFrame.from_file(args.path+args.validation+'.shp',crs=crs)
segments = gpd.GeoDataFrame.from_file(args.path+args.segments+'.shp',crs=crs)

# spatial join between segmentation results and validation data

print("------ Spatial join ------ ")
pointInPolys = sjoin(segments , validation, how='left',op='within')
#print(pointInPolys.head())

# vote for the most frequently presented class

print("------ Voting ------ ")

pointInPolys['Open water'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Open water')].count())
pointInPolys['Struweel'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Struweel')].count())
pointInPolys['Bos'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Bos')].count())
pointInPolys['Grasland'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Grasland')].count())
pointInPolys['Landriet, structuurrijk'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Landriet, structuurrijk')].count())
pointInPolys['Landriet, structuurarm'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Landriet, structuurarm')].count())
pointInPolys['Waterriet'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Waterriet')].count())

pointInPolys['Highestfreq'] = pointInPolys[['Open water','Struweel','Bos','Grasland','Landriet, structuurrijk','Landriet, structuurarm','Waterriet']].max(axis=1)
pointInPolys['Sumfreq'] = pointInPolys[['Open water','Struweel','Bos','Grasland','Landriet, structuurrijk','Landriet, structuurarm','Waterriet']].sum(axis=1)
pointInPolys['Highestid'] = pointInPolys[['Open water','Struweel','Bos','Grasland','Landriet, structuurrijk','Landriet, structuurarm','Waterriet']].idxmax(axis=1)
#print(pointInPolys.head())

# export results

print("------ Export ------ ")
pointInPolys.to_file(args.path+args.segments+'.wlabeledsegment.shp', driver='ESRI Shapefile')


