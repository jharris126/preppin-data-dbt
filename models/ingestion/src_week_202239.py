from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1p5Dn8DR4XDPmfEv4MQL-1C0EJZO4t97P&export=download"
    return read_csv(source_data_url)
