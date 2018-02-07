## Fix the path (temporary)
import sys
sys.path.insert(0, 'D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/')

## Import libraries
from laserchicken import read_las
from laserchicken.spatial_selections import points_in_polygon_wkt

from laserchicken.keys import point

from laserchicken.compute_neighbors import compute_neighbourhoods, compute_cylinder_neighborhood_indices, compute_sphere_neighborhood_indices
from laserchicken.feature_extractor.height_statistics_feature_extractor import HeightStatisticsFeatureExtractor

from laserchicken import write_ply

## Read-Write
pc = read_las.read("D:/NAEM/Data/ALS_AHN2/SelStudyArea2_v2.las")
pc_sub = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

#write_ply.write(pc_sub, "D:/NAEM/Data/ALS_AHN2/SelStudyArea2_v3.ply")

## Compute neighborhood

#indices_cyl=compute_cylinder_neighborhood_indices(pc_sub, pc_sub,1)
indices_sph=compute_sphere_neighborhood_indices(pc_sub, pc_sub,1)

output_text = ""

for i in range(len(indices_sph)):
    extractor = HeightStatisticsFeatureExtractor()
    max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z = extractor.extract(pc_sub,indices_sph[i],None,None,None)

    output_text += "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n" % (pc_sub[point]['x']['data'][i],pc_sub[point]['y']['data'][i],pc_sub[point]['z']['data'][i],max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z)

fileout = open('D:/NAEM/Data/ALS_AHN2/SelStudyArea2_withfea1.txt', "w")
fileout.write(output_text)
fileout.close()
