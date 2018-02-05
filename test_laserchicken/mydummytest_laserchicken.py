import sys
sys.path.insert(0, 'C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/eEcoLiDAR/')

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken import write_ply
from laserchicken import compute_neighbors
from laserchicken.feature_extractor.height_statistics_feature_extractor import HeightStatisticsFeatureExtractor

pc = read_las.read("C:/zsofia/Amsterdam/GitHub/eEcoLiDAR/eEcoLiDAR/testdata/AHN2.las")
pc_out = points_in_polygon_wkt(pc, "POLYGON(( 243590.0 572110.0, 243640.0 572160.0, 243700.0 572110.0, 243640.0 572060.0, 243590.0 572110.0 ))")

indices=compute_neighbors.compute_cylinder_neighbourhood_indicies(pc_out, pc_out, 2.5)
#print(len(indices))
#print(pc_out[point]['z']['data'][indices])

extractor = HeightStatisticsFeatureExtractor()
(max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z) = extractor.extract(pc_out, indices,None,None)

write_ply.write(pc_out, "C:/zsofia/Amsterdam/GitHub/komazsofi/myPhD_escience_analysis/test_data/withinplygonply_hightfea.ply")



