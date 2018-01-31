import sys
sys.path.insert(0, 'D:/GitHub/eEcoLiDAR/eEcoLiDAR/')

from laserchicken import read_las

pc_in = read_las.read("D:/GitHub/eEcoLiDAR/eEcoLiDAR/testdata/AHN2.las")

print(pc_in)

