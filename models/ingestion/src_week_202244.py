from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1b9KuMlut8mO2LR-zpMe6Ek0XDS8Wcj6D&export=download"
    return read_csv(source_data_url)
