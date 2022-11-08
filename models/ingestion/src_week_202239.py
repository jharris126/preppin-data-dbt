def model(dbt, session):
    import requests
    from io import BytesIO
    from pyarrow.csv import read_csv

    source_data_url = 'https://drive.google.com/u/0/uc?id=1p5Dn8DR4XDPmfEv4MQL-1C0EJZO4t97P&export=download'
    csv_text = requests.get(source_data_url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)

    return read_csv(csv_data)
