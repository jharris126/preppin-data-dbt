from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1g6-c0yy9SzmfLOT6jywt6YUb2LrylJwb&export=download"
    return read_csv(source_data_url)