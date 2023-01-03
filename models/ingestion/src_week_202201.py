from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1p8gt3cR3ATCeGK81pnT90x0a6dbCXst1&export=download"
    return read_csv(source_data_url)
