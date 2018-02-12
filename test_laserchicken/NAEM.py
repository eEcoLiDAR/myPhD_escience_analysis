from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken import compute_neighbors
from laserchicken.feature_extractor.height_statistics_feature_extractor import HeightStatisticsFeatureExtractor

import numpy as np

# Import
pc = read_las.read("D:/NAEM/Data/ALS_AHN2/SelStudyArea2_sel1_ground_height.las")
pc_out = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

#"""
# Neighborhood calculation
indices_cyl=compute_neighbors.compute_cylinder_neighborhood_indices(pc_out, pc_out, 0.5)
indices_sph=compute_neighbors.compute_sphere_neighborhood_indices(pc_out, pc_out, 1)

# Statistical descriptor feature calculation
output_text = ""

for i in range(len(indices_sph)):
    extractor = HeightStatisticsFeatureExtractor()
    max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z = extractor.extract(pc_out,indices_sph[i],None,None,None)

    output_text += "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n" % (pc_out[point]['x']['data'][i],pc_out[point]['y']['data'][i],pc_out[point]['z']['data'][i],max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z)

fileout = open('D:/NAEM/Data/ALS_AHN2/SelStudyArea2_statsph.txt', "w")
fileout.write(output_text)
fileout.close()

output_text2 = ""

for i in range(len(indices_cyl)):
    extractor = HeightStatisticsFeatureExtractor()
    max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z = extractor.extract(pc_out,indices_cyl[i],None,None,None)

    output_text2 += "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \n" % (pc_out[point]['x']['data'][i],pc_out[point]['y']['data'][i],pc_out[point]['z']['data'][i],max_z, min_z, mean_z, median_z, std_z, var_z, range_z, coeff_var_z, skew_z, kurto_z)

fileout = open('D:/NAEM/Data/ALS_AHN2/SelStudyArea2_statcyl.txt', "w")
fileout.write(output_text2)
fileout.close()
#"""

# Pulse penetration ratio
z=pc_out[point]['z']['data']
step=1

def nofp_per_perc(z,step):
    nof_perc_to_total=""

    for i in range(0,np.int(max(z)),step):
        nof_perc_to_total_calc=(z[(np.where((z>i)&(z<i+step)))].shape[0]/z.shape[0])*100
        #print(z[(np.where((z>i)&(z<i+step)))].shape[0])
        #print(nof_perc_to_total_calc)
        nof_perc_to_total += "%s,%s \n" % (nof_perc_to_total_calc,i+step/2)

    return nof_perc_to_total

nof_perc_to_total=nofp_per_perc(z,step)
#print(nof_perc_to_total)

fileout = open('D:/NAEM/Data/ALS_AHN2/nof_perc_to_total.txt', "w")
fileout.write(nof_perc_to_total)
fileout.close()

