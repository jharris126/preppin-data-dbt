def model(dbt, session):
    from pandas import read_csv

    source_data_url = "https://docs.google.com/spreadsheets/d/1dXtK_0xQWj5gG-sj21JqmE2jYLtk6yfU/export?format=csv"

    return read_csv(source_data_url)
