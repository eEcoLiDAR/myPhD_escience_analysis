import pandas as pd

filepath="D:/GitHub/eEcoLiDAR/Annotation/Data/"

speciestable=pd.read_csv(filepath+'speciestable.csv',sep=';',encoding='latin-1')
plottable=pd.read_csv(filepath+'plottable.csv',sep=';',encoding='latin-1')
observationtable=pd.read_csv(filepath+'observationtable.csv',sep=';',encoding='latin-1')

def filterbyyear(observationtable,plottable,speciestable,year,habitat):
    observationtable_upyear=observationtable[(observationtable["year"]>year)]

    joined_obsplot=pd.merge(observationtable_upyear, plottable, on='polygonID', how='left')
    joined_obsplot = joined_obsplot[list(joined_obsplot.columns[~joined_obsplot.columns.duplicated()])]

    joined_obsplot_forest=joined_obsplot[(joined_obsplot["habitat"]==habitat)]
    joined_db=pd.merge(joined_obsplot_forest, speciestable, on='speciesKey', how='left')

    return joined_db

def extractspecies(joined_db,plottable,species,covermax,covermin):
    joined_db_species = joined_db[(joined_db["species"] == species) & (joined_db["organismQuantity"] < covermax) & (joined_db["organismQuantity"] > covermin)]

    print(joined_db_species)

    joined_db_species_all = pd.merge(joined_db, joined_db_species[["polygonID"]], on='polygonID',how='right')
    specieslist = joined_db_species_all.groupby('polygonID')['species'].apply(list).reset_index()
    coveragelist = joined_db_species_all.groupby('polygonID')['organismQuantity'].apply(list).reset_index()

    lists = pd.merge(specieslist, coveragelist, on='polygonID', how='left')

    outputlist = pd.merge(lists, plottable[['polygonID', 'footprintWKT']], on='polygonID',how='left')

    outputlist.to_csv(filepath+str(species)+"_"+str(covermax)+"_"+str(covermin)+'.csv', sep=";", index=False)

joined_db=filterbyyear(observationtable,plottable,speciestable,2007,"Forest")
print(joined_db.shape)

extractspecies(joined_db,plottable,"Quercus robur",50,10)