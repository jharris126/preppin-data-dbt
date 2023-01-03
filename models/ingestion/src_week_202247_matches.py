from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1fC19ZLvUeM1B1Iyn3tVkR0qcrwM-Pb13&export=download"
    return read_csv(source_data_url, encoding='latin-1')
