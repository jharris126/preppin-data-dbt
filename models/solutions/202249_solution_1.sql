with file_time_parse as (
    select
        candidate_id,
        position_id,
        status,
        ts,
        filename,
        strptime(right(string_split(filename, '.csv')[1], 19), '%Y-%m-%d_%H-%M-%S') as file_time
    from {{ ref("src_week_202249") }}
),

file_time_rank as (
    select
        candidate_id,
        position_id,
        status,
        ts,
        filename,
        file_time,
        dense_rank() over(partition by candidate_id, position_id order by file_time desc) as file_rank
    from file_time_parse
    qualify file_rank = 1
)

select
    candidate_id,
    position_id,
    status,
    cast(ts as datetime) as ts,
    filename
from file_time_rank
