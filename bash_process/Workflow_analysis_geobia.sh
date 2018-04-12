: '
@author: Zsofia Koma, UvA
Aim: pipeline for pre-processing the output results from feature derivation (using laserchicken) for the segmentation process  

Example usage (from command line):  bash D:/GitHub/eEcoLiDAR/myPhD_escience_analysis/bash_process/Workflow_analysis_geobia.sh

ToDo: 
1. Fix GRASS GIS path to able to provide only one pipeline for processing the data
2. For cycle processing the files on by one ?
'

work_folder="D:/Geobia_2018/Results_12ofApril/"

# Convert ply files into cleaned text file and merge it together

echo "--------Conversion is started--------"

for f in $work_folder*.ply;do python ply_tograss.py ${f%.ply};done
cat $work_folder*_clean.txt > $work_folder/all_tiles_clean.txt

# PCA analysis and determine most important PCs

echo "--------PCA analysis is started--------"

python pca_geobia.py $work_folder/all_tiles_clean.txt 

# switch to grass gis pipeline output file: csv with the PCA components
