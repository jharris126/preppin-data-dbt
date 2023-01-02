from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1Y_oTAAD92502j-40bXtX3V3Q38W-s2MW&export=download"
    return read_csv(source_data_url)
