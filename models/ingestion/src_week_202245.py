def model(dbt, session):
    import pandas as pd
    import itertools

    source_data_url = "https://docs.google.com/spreadsheets/d/1yl90nKrQzpAgm3oYgrS44d3iX73VphSz/export?format=csv"
    data = pd.read_csv(source_data_url, skiprows=2, header=[0, 1]).values
    cols_maker = itertools.product(
        ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct"],
        ["sales", "profit"],
    )
    cols = ["_".join(col) for col in list(cols_maker)]
    cols.insert(0, "store")

    return pd.DataFrame(data, columns=cols)
