from shapely.geometry import mapping
from shapely.wkt import loads
from fiona import collection

from pandas import DataFrame
from geopandas import GeoDataFrame

def polyarea(vegdb_dataframe):
    geometry = vegdb_dataframe['footprintWKT'].map(loads)
    crs = {'init': 'epsg:18992'}
    geovegdb_dataframe = GeoDataFrame(vegdb_dataframe, crs=crs, geometry=geometry)
    return geovegdb_dataframe['geometry'].area


def polygonize_dwc(vegdb_dataframe,shapefilename):
    vegddb=vegdb_dataframe.groupby('polygonID').first().reset_index()
    geometry = vegddb['footprintWKT'].map(loads)
    crs = {'init': 'epsg:18992'}
    geovegdb_dataframe = GeoDataFrame(vegddb[["footprintWKT","polygonID"]], crs=crs, geometry=geometry)
    geovegdb_dataframe.to_file(shapefilename+".shp", driver='ESRI Shapefile')

