from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://docs.google.com/spreadsheets/d/1RsP8ANXAMN66XObcBkuwDuF1-b9CL3Xg/export?format=csv&gid=2076379781"
    return read_csv(source_data_url)
