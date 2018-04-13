: '
@author: Zsofia Koma, UvA
Aim: pipeline for processing the output results from feature derivation (using laserchicken) 
1. Convert data into the right format
2. PCA analysis
3. Segmentation in GRASS GIS
4.  

Example usage (from command line):  bash D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/bash_process/Workflow_analysis_geobia.sh

ToDo: 
1. Get the boundary automatically
'

work_folder="D:/Geobia_2018/Results_12ofApril/"
script_path="D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/"

grass_path="C:/OSGeo4W64/bin/"
grass_mapset="D:/Geobia_2018/Results_12ofApril/GrassGIS/LauMeer" #should set up beforehand

n=600000
s=597000
e=220000
w=206000

# Convert ply files into cleaned text file and merge it together

echo "--------Conversion is started--------"

#for f in $work_folder*.ply;do python $script_path/analysis/ply_tograss.py ${f%.ply};done
#cat $work_folder*_clean.txt > $work_folder/all_tiles_clean.txt

# PCA analysis and determine most important PCs

echo "--------PCA analysis is started--------"

#python $script_path/analysis/pca_geobia.py $work_folder/all_tiles_clean.txt 

echo "--------Segmentation started--------"

# GRASS GIS segmentation
$grass_path/grass74.bat --exec $script_path/grassgis_process/grass_segmentation_whinwflow.bat $grass_mapset $work_folder all_tiles_clean $n $s $e $w
