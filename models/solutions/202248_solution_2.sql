select
    cast(string_split("event", 'World Singles ')[2] as int) as event_id,
    string_split("Competitors", ' (')[1] as competitor,
    event,
    cast(
        strptime(
            trim(string_split(string_split(description, '·')[1], ' and ')[1]),
            '%-d %B %Y'
        ) as date
    ) as event_start_date,
    description as event_description,
    replace(string_split("Competitors", ' (')[2], ')', '') as association,
    cast(
        replace(
            replace(
                replace(
                    "Pts", '½', '.5'
                ), '⅔', '.66666'
            ), '⅓', '.33333'
        ) as numeric(8, 6)
    ) as points,
    "W" as wins,
    "L" as losses,
    "T" as ties
from {{ ref("src_week_202248") }}
