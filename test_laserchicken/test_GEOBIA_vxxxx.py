from laserchicken import read_las
from laserchicken import write_ply
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.volume_specification import Sphere, InfiniteCylinder
from laserchicken.feature_extractor import compute_features

import numpy as np

# Import
pc = read_las.read("D:/Wetland/GEOBIA/Data/AHN2/12en1_sel2_ground_height_clipped.las")

# Neighborhood calculation

indices_cyl=compute_neighborhoods(pc, pc, InfiniteCylinder(5))

for i in range(len(indices_cyl)):
    features=compute_features(pc, indices_cyl, pc, ['eigenv_1', 'eigenv_2', 'eigenv_3'], InfiniteCylinder(5))
    print(features)



