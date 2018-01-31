import sys
sys.path.insert(0, 'D:/GitHub/eEcoLiDAR/eEcoLiDAR/')

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt

import matplotlib.pyplot as plt
import matplotlib.cm as cm
from mpl_toolkits.mplot3d import Axes3D

pc_in = read_las.read("D:/GitHub/eEcoLiDAR/eEcoLiDAR/testdata/AHN2.las")
pc_out = points_in_polygon_wkt(pc_in, "POLYGON(( 243590.0 572110.0, 243640.0 572160.0, 243700.0 572110.0, 243640.0 572060.0, 243590.0 572110.0 ))")

print(pc_out[point]['y']['data'])

#fig = plt.figure()
#ax1 = fig.add_subplot(111, projection='3d')
#ax1.scatter(pc_out[point]['x']['data'], pc_out[point]['y']['data'],pc_out[point]['z']['data'])
#ax1.set_xlabel('X')
#ax1.set_ylabel('Y')
#ax1.set_zlabel('Z')
#ax1.azim = 65
#ax1.elev = 5
#plt.show()


