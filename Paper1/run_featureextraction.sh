: '
@author: Zsofia Koma, UvA
Aim: extract vegetation related features with laserchicken
'

# set global variables

path="D:/Koma/Paper1_ReedStructure/1_ProcessingLiDAR/02gz2/tiled/"

#python vegfeaturecalc_norm.py $path tile_1_0.las_ground.las_ground_norm 
#python vegfeaturecalc_non_norm.py $path tile_1_0.las_ground

#for f in $path/*.las_ground.las_ground_norm.las; do python vegfeaturecalc_norm.py ${f%.*};done
#for f in $path/*.las_ground.las; do python vegfeaturecalc_non_norm.py ${f%.*};done