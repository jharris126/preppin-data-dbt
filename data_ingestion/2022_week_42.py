from helper import google_csv_to_arrow, arrow_to_duckdb


source_data_url = 'https://drive.google.com/u/0/uc?id=1d4ItvcaPATxbFevMOfAIXXpchOh-09D_&export=download'
df = google_csv_to_arrow(source_data_url)
arrow_to_duckdb('df', 'src_week_202242')
