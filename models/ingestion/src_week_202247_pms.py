from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://docs.google.com/spreadsheets/d/1rW5hiRObdXwzkAoVJL2jcuiOUot_pyXL/export?format=csv"
    return read_csv(source_data_url)
