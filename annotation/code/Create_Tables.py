import pandas as pd

def create_speciestable(vegdb_dataframe):
    groupby_spname = vegdb_dataframe.groupby("speciesKey")
    sp_table=""
    for speciesKey, group in groupby_spname:
        sp_table += "%i;%s;%s;%s;%s;%s;%s;%s;%s;%s \n" % (group["speciesKey"].unique()[0],group["species"].unique()[0],group["kingdom"].unique()[0],group["phylum"].unique()[0],group["class"].unique()[0],group["order"].unique()[0],group["family"].unique()[0],
                                group["genus"].unique()[0],group["specificEpithet"].unique()[0],group["vernacularName"].unique()[0])
    return sp_table

def create_plotID(vegdb_dataframe):
    vegdb_dataframe['polygonID'] = pd.Categorical(vegdb_dataframe['footprintWKT'].astype(str)).codes
    return vegdb_dataframe

def create_plottable(vegdb_dataframe):
    groupby_plotid = vegdb_dataframe.groupby('polygonID')
    plot_table=""
    for location, group in groupby_plotid:
        plot_table+= "%s;%f;%f;%f;%s;%s;%s;%f;%s;%f \n" % (group["polygonID"].unique()[0],group["decimalLatitude"].unique()[0],group["decimalLongitude"].unique()[0],group["coordinateUncertaintyInMeters"].unique()[0],group["footprintWKT"].unique()[0],
                                                        group["habitat"].unique()[0],group["samplingProtocol"].unique()[0],group["sampleSizeValue"].unique()[0],
                                                        group["sampleSizeUnit"].unique()[0],group["area"].unique()[0])
    return plot_table

def create_observtable(vegdb_dataframe,nameofoutput):
    obs_table = vegdb_dataframe[["polygonID","eventID","speciesKey","year","month","day","eventDate","organismQuantity","organismQuantityType"]]
    obs_table = obs_table[pd.isnull(obs_table.speciesKey) == False]
    obs_table = obs_table[pd.isnull(obs_table.year) == False]
    obs_table.to_csv(nameofoutput+'.csv',sep=";",index=False)

def export_table(table,header,nameofoutput):
    fileout = open(nameofoutput+'.csv', "a")
    fileout.write(header)
    fileout.write(table)
    fileout.close()