def model(dbt, session):
    import requests
    from io import BytesIO
    from pyarrow.csv import read_csv

    source_data_url = "https://drive.google.com/u/0/uc?id=1fC19ZLvUeM1B1Iyn3tVkR0qcrwM-Pb13&export=download"
    csv_text = requests.get(source_data_url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)

    return read_csv(csv_data)
