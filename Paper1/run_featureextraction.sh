: '
@author: Zsofia Koma, UvA
Aim: extract vegetation related features with laserchicken
'

# set global variables

path="D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/"

for f in $path/*.las_ground.las; do python vegfeaturecalc_non_norm.py ${f%.*};done