import requests
from io import BytesIO
from pyarrow.csv import read_csv
from pyarrow import Table
from os import environ
import duckdb


def get_duckdb_path() -> str:
    return environ['DUCKDB_PATH']

def google_csv_to_arrow(url: str) -> Table:
    csv_text = requests.get(url).text
    csv_bytes = str.encode(csv_text)
    csv_data = BytesIO(csv_bytes)

    return read_csv(csv_data)

def arrow_to_duckdb(arrow_table_name: str, duckdb_table_name: str):
    with duckdb.connect(get_duckdb_path()) as con:
        sql = f"""
            create or replace table {duckdb_table_name} as
            select
                *,
                now() as "_loaded_at"
            from "{arrow_table_name}";
        """
        con.execute(sql)
