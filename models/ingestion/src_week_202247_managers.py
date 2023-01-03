from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://docs.google.com/spreadsheets/d/1WoWZkIjdqVg34LMSgNXnLNYWhF2iqs77/export?format=csv"
    df = read_csv(source_data_url)
    df['row_num'] = df.index
    return df
