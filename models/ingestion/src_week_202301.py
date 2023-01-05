from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1oln2ri6nu1wDQfT3gQMLLNlmQ2h6B9d9&export=download"
    return read_csv(source_data_url)
