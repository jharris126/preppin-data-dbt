def model(dbt, session):
    import requests
    from io import BytesIO
    from pyarrow.csv import read_csv

    source_data_url = 'https://drive.google.com/u/0/uc?id=1b9KuMlut8mO2LR-zpMe6Ek0XDS8Wcj6D&export=download'
    csv_text = requests.get(source_data_url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)

    return read_csv(csv_data)
