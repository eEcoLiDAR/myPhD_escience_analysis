"""
@author: Zsofia Koma, UvA
Aim: 

Input: 
Output: 

Example usage (from command line):   python assignclassvalues.py D:/Geobia_2018/Lauw_island_tiles/ vlakken_union_structuur test2points

ToDo: 
1. 

"""

import sys
import argparse

import numpy as np
import pandas as pd
import geopandas as gpd

from shapely.geometry import Point
from geopandas.tools import sjoin


parser = argparse.ArgumentParser()
parser.add_argument('path', help='where the files are located')
parser.add_argument('training', help='name of polygon')
parser.add_argument('segments', help='name of the shp file with segmentID')
args = parser.parse_args()

# read the training polygon and assign the value related to a points shape file (created from the raster results of the segmentation)

crs = {'init': 'epsg:28992'}

training = gpd.GeoDataFrame.from_file(args.path+args.training+'.shp',crs=crs)

segments = gpd.GeoDataFrame.from_file(args.path+args.segments+'.shp',crs=crs)

pointInPolys = sjoin(segments , training, how='left',op='within')
#print(pointInPolys.head())

#segment_groups=pointInPolys.groupby('value')['structyp_e'].apply(lambda x: x[x.str.contains('Open water')].count())

pointInPolys['Open water'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Open water')].count())
pointInPolys['Struweel'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Struweel')].count())
pointInPolys['Bos'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Bos')].count())
pointInPolys['Grasland'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Grasland')].count())
pointInPolys['Landriet, structuurrijk'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Landriet, structuurrijk')].count())
pointInPolys['Landriet, structuurarm'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Landriet, structuurarm')].count())
pointInPolys['Waterriet'] = pointInPolys.groupby('value')['structyp_e'].transform(lambda x: x[x.str.contains('Waterriet')].count())
#print(pointInPolys.head())

pointInPolys.drop_duplicates('value').to_csv(args.path+args.segments+'wclass_possib.csv',sep=',',index=False)

#pointInPolys.to_file(args.path+args.segments+'wsegment.shp', driver='ESRI Shapefile')


