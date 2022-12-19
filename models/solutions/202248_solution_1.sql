with games_pivot as (
    select
        cast(string_split("event", 'World Singles ')[2] as int) as event_id,
        string_split("Competitors", ' (')[1] as competitor,
        unnest(
            list_value(
                concat('G1|', G1),
                concat('G2|', G2),
                concat('G3|', G3),
                concat('G4|', G4),
                concat('G5|', G5),
                concat('G6|', G6),
                concat('G7|', G7),
                concat('G8|', G8)
            )
        ) as game_info,
        note
    from {{ ref("src_week_202248") }}
)

select
    event_id,
    competitor,
    string_split(game_info, '|')[1] as game_order,
    cast(
        replace(
            replace(
                replace(
                    replace(
                        string_split(game_info, '|')[2], '½', '.5'
                    ), '⅔', '.66666'
                ), '⅓', '.33333'
            ), '*', ''
        ) as numeric(8, 6)
    ) as score,
    case
        when right(string_split(game_info, '|')[2], 1) = '*' then TRUE
        else FALSE
    end as potout,
    note
from games_pivot
where string_split(game_info, '|')[2] not in ('', 'NA')
