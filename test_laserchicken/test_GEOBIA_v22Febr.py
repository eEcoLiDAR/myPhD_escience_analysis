from laserchicken import read_las
from laserchicken import write_ply
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.volume_specification import Sphere, InfiniteCylinder
from laserchicken.feature_extractor import compute_features

import numpy as np
import time

# Import
pc = read_las.read("D:/NAEM/Data/ALS_AHN2/SelStudyArea2_v2.las")
pc_sub = points_in_polygon_wkt(pc, "POLYGON((196550 446510,196550 446540,196580 446540,196580 446510,196550 446510))")

# Neighborhood calculation

start = time.time()
indices_cyl=compute_neighborhoods(pc_sub, pc_sub, InfiniteCylinder(5))
end = time.time()
difftime=end - start
print(("build kd-tree: %f sec") % (difftime))

output_text1 = ""
start1 = time.time()
for i in range(len(indices_cyl)):
    compute_features(pc_sub, indices_cyl, pc_sub, ['max_z','sigma_z'], InfiniteCylinder(5))

    output_text1 += "%s,%s,%s,%s,%s \n" % (
    pc_sub[point]['x']['data'][i], pc_sub[point]['y']['data'][i], pc_sub[point]['z']['data'][i],pc_sub[point]['max_z']['data'],pc_sub[point]['sigma_z']['data'])

end1 = time.time()
difftime1=end1 - start1
print(("New laserchicken version calculation of max z took: %f sec") % (difftime1))

fileout = open('D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/SelStudyArea2_withfea.txt', "w")
fileout.write(output_text1)
fileout.close()

output_text2 = ""
start2 = time.time()
for i in range(len(indices_cyl)):
    max_z=np.max(pc_sub[point]['z']['data'][indices_cyl[i]])
    output_text2 += "%s,%s,%s,%s\n" % (
    pc_sub[point]['x']['data'][i], pc_sub[point]['y']['data'][i], pc_sub[point]['z']['data'][i],max_z)
end2 = time.time()
difftime2=end2 - start2
print(("Simple calculation of max z took: %f sec") % (difftime2))

fileout = open('D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/SelStudyArea2_withfea2.txt', "w")
fileout.write(output_text2)
fileout.close()

