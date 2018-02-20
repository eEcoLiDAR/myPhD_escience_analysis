from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken.compute_neighbors import compute_neighborhoods
from laserchicken.volume_specification import Sphere, InfiniteCylinder

import numpy as np

# Import
pc = read_las.read("D:/Wetland/GEOBIA/Data/AHN2/12en1_sel2_ground_height.las")
pc_clipped = points_in_polygon_wkt(pc, "POLYGON((243255 571793,243262 571368,243548 571628, 243255 571793))")

# Neighborhood calculation

indices_cyl=compute_neighborhoods(pc_clipped, pc_clipped, InfiniteCylinder(2))



