# download the data from WebDAV derive neighborhood based features

passw="$(<D:/GitHub/passw.txt)"
path_of_laserchicken="D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/"
path_of_pythonscripts="D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken"

localinput="D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/"

filename=$1
#filename="${filename1%%[[:cntrl:]]}"
radius=$2
volume=$3

curl --insecure --fail --location --user $passw https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Data/Lauwersmeer/$filename.las --output $localinput$filename.las 

# kd-tree

#python D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken/kdtree_geobia_sphere.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_sphere4.pkl 4

python $path_of_pythonscripts/kdtree_geobia_$volume.py $path_of_laserchicken $localinput$filename.las $localinput$filename._cylinder$radius.pkl $radius

# feature calculation

#python D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken/computefea_geobia_cylinder.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.pkl D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.ply 4

# upload the data to WebDAV and delete on the local machines

echo "--------Upload is started--------"

curl --insecure --fail --location --user $passw --upload-file $localinput$filename._$volume$radius.pkl https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/KdTree/

echo "--------Remove unnecessary files--------"

rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.pkl
rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.las
rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.csv

echo "--------Script is finished--------"