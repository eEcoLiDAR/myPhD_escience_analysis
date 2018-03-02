# download the data from WebDAV derive neighborhood based features

passw="$(<D:/GitHub/passw.txt)"
path_of_laserchicken="D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/"
path_of_pythonscripts="D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken"

localinput="D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/"

filename=$1
#filename="${filename1%%[[:cntrl:]]}"
radius=$2
volume=$3

curl --insecure --fail --location --user $passw https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/Data/$filename.las --output $localinput$filename.las 

# kd-tree

python $path_of_pythonscripts/kdtree_geobia_$volume.py $path_of_laserchicken $localinput$filename.las $localinput$filename._cylinder$radius.pkl $radius

# feature calculation

python $path_of_pythonscripts/computefea_geobia_$volume.py $path_of_laserchicken $localinput$filename.las $localinput$filename._cylinder$radius.pkl $localinput$filename._cylinder$radius.csv $radius

echo "--------Upload is started--------"

curl --insecure --fail --location --user $passw --upload-file $localinput$filename._$volume$radius.pkl https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/KdTree/
curl --insecure --fail --location --user $passw --upload-file $localinput$filename._$volume$radius.csv https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/Features/

echo "--------Remove unnecessary files--------"

rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.pkl
rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.las
rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.csv

echo "--------Script is finished--------"