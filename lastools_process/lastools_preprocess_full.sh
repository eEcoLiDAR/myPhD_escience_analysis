#
#@author: Zsofia Koma, UvA

#Aim: preprocess ALS data classify into ground, vegetation, water (using an extra polygon) and normalize the height 
#1. Import las file
#2. Create tiles (500m*500m of each)
#3. Classify into ground, vegetation, water 
#4. Normalize height
#5. Export

#Usage example from Git bash on a windows machine: bash lastools_preprocess_full.sh C:/LAStools/bin D:/Koma/Data/ 06en2_merged studyarea waterpoly

# ToDo: build in lasindex for optimizing the process

# Initialize some variables from the command line
lastoolspath=$1
localinput=$2
filename=$3
poly_AOI=$4 #area of interest 
poly_water=$5

#mkdir $localinput/tiles2 #here save the tiles

# process the data
#$lastoolspath/lasclip -i $localinput$filename.las -o $localinput$filename._aoi.las -poly $localinput$poly_AOI.shp -v 
#$lastoolspath/lasclip -i $localinput$filename._aoi.las -o $localinput$filename._aoi_w.las -poly $localinput$poly_water.shp -classify 9 -interior

#$lastoolspath/lastile -i $localinput$filename._aoi_w.las -o $localinput/tiles2/tile.las -tile_size 500

$lastoolspath/lasground_new -i $localinput/tiles2/*.las -step 1 -olas -cores 16 -ignore_class 9
$lastoolspath/lasheight -i $localinput/tiles2/*_1.las -olas -replace_z