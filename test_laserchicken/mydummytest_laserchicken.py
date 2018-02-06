import sys
sys.path.insert(0, 'D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/')

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken import write_ply
from laserchicken import compute_neighbors
from laserchicken.feature_extractor.height_statistics_feature_extractor import HeightStatisticsFeatureExtractor

pc = read_las.read("D:/NAEM/Data/ALS_AHN2/SelStudyArea2_v2.las")
pc_out = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

indices=compute_neighbors.compute_cylinder_neighbourhood_indicies(pc_out, pc_out, 0.5)
#print(np.array(indices).shape)
#print(pc_out[point]['z']['data'][indices])
write_ply.write(pc_out, "D:/NAEM/Data/ALS_AHN2/SelStudyArea2.ply")

output_text = ""

for i in range(len(indices)):
    extractor = HeightStatisticsFeatureExtractor()
    max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z = extractor.extract(pc_out,indices[i],None,None)

    output_text += "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n" % (pc_out[point]['x']['data'][i],pc_out[point]['y']['data'][i],pc_out[point]['z']['data'][i],max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z)

fileout = open('D:/NAEM/Data/ALS_AHN2/SelStudyArea2_withfea.txt', "w")
fileout.write(output_text)
fileout.close()

