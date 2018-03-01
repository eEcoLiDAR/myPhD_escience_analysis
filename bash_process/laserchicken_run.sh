# download the data from WebDAV

passw="$(<D:/GitHub/passw.txt)"

#curl --insecure --fail --location --user $passw https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Data/Lauwersmeer/02gz2_merged_kiv1_kivtest.las --output D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las 
#curl --insecure --fail --location --user zkoma https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Data/Lauwersmeer/02gz2_merged_kiv1_kivtest.las --output D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las

# kd-tree

#python D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken/kdtree_geobia_sphere.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_sphere4.pkl 4

#python D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken/kdtree_geobia_cylinder.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.pkl 4

# feature calculation

python D:/GitHub/komazsofi/myPhD_escience_analysis/test_laserchicken/computefea_geobia_cylinder.py D:/GitHub/eEcoLiDAR/develop-branch/eEcoLiDAR/ D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest.las D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.pkl D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.ply 4

# upload the data to WebDAV and delete on the local machines

echo "--------Upload is started--------"

#curl --insecure --fail --location --user $passw --upload-file D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_sphere4.pkl https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/
#curl --insecure --fail --location --user $passw --upload-file D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/m02gz2_merged_kiv1_kivtest_cylinder4.pkl https://webdav.grid.sara.nl/pnfs/grid.sara.nl/data/projects.nl/eecolidar/01_Work/zsofia/geobia/Results/

echo "--------Remove unnecessary files--------"

#rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.pkl
#rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.las
#rm D:/GitHub/komazsofi/myPhD_escience_analysis/test_data/*.csv

echo "--------Script is finished--------"