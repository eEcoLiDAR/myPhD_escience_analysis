import sys
sys.path.insert(0, 'D:/GitHub/eEcoLiDAR/eEcoLiDAR/')

from laserchicken import read_las
from laserchicken.keys import point
from laserchicken.spatial_selections import points_in_polygon_wkt
from laserchicken import write_ply

pc = read_las.read("D:/GitHub/eEcoLiDAR/eEcoLiDAR/testdata/AHN2.las")

write_ply.write(pc, "D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/testply_orig.ply")

pc_out = points_in_polygon_wkt(pc, "POLYGON(( 243590.0 572110.0, 243640.0 572160.0, 243700.0 572110.0, 243640.0 572060.0, 243590.0 572110.0 ))")

write_ply.write(pc_out, "D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/withinplygonply.ply")



