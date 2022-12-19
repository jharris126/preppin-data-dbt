def model(dbt, session):
    import requests
    from io import BytesIO
    from pandas import read_csv

    source_data_url = "https://docs.google.com/spreadsheets/d/1WoWZkIjdqVg34LMSgNXnLNYWhF2iqs77/export?format=csv"
    csv_text = requests.get(source_data_url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)
    df = read_csv(csv_data)
    df['row_num'] = df.index

    return df
