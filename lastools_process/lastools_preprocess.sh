# download the data from WebDAV and normalized the height with lastools

passw="$(<C:/zsofia/Amsterdam/GitHub/passw.txt)"
LAStoolspath="C:/additional_softwares/LAStools/LAStools/bin"

localinput="C:/zsofia/Amsterdam/GitHub/komazsofi/myPhD_escience_analysis/test_data/"
filename="m02gz2_merged_kiv1_kivtest"

echo "--------Download is started $filename--------"

curl --insecure --fail --location --user $passw https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Data/Lauwersmeer/02gz2_merged_kiv1_kivtest.las --output $localinput$filename.las 

echo "--------LAStools process is started--------"

$LAStoolspath/lasground_new -i $localinput$filename.las -o $localinput$filename._ground.las -step 1
$LAStoolspath/lasheight -i $localinput$filename._ground.las -o $localinput$filename._ground_height.las -replace_z

echo "--------Upload is started--------"

curl --insecure --fail --location --user $passw --upload-file $localinput$filename._ground_height.las https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/Data/

rm $localinput/*.las

echo "--------Script is finished the process of $filename--------"