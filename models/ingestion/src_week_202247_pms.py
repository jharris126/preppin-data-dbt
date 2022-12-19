def model(dbt, session):
    import requests
    from io import BytesIO
    from pyarrow.csv import read_csv

    source_data_url = "https://docs.google.com/spreadsheets/d/1rW5hiRObdXwzkAoVJL2jcuiOUot_pyXL/export?format=csv"
    csv_text = requests.get(source_data_url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)

    return read_csv(csv_data)
