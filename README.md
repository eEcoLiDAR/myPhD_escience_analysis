This repository aims to collect the codes and analysis which was done on a preliminary basis for my PhD within the [e-EcoLiDAR project](https://www.esciencecenter.nl/project/eecolidar).  

The components of the analysis scripts are the following:

- test_laserchicken: 
Continuous testing of the development branch of the [laserchicken](https://github.com/eEcoLiDAR/laserchicken) point cloud analysis software. Further this directory will contain an documentation how to use laserchicken (under progress). 

- annotation:
Preliminary test and processing of different annotation data for our project. 

- bash_process:
Complete workflow (pipelines) for a defined task within the project (for example wetland classification). Here I used together the developed scripts from the various subdirectories within this repository.

- grassgis_process:
Batch files which was used within [GRASS GIS](https://grass.osgeo.org/) for prcessing the LiDAR data. 

- lastools_process:
Bash files (with wine) for using [LAStools](https://rapidlasso.com/lastools/) for some preprocessing step (tiling, classifying the data). 
