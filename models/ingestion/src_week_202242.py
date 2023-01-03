from pandas import read_csv

def model(dbt, session):
    source_data_url = "https://drive.google.com/u/0/uc?id=1d4ItvcaPATxbFevMOfAIXXpchOh-09D_&export=download"
    return read_csv(source_data_url)
