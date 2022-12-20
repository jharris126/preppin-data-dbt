with rank_and_filter as (
    select
        candidate_id,
        position_id,
        status,
        row_number() over(partition by candidate_id, position_id order by ts desc) as status_rank,
        ts
    from {{ ref("202249_solution_1") }}
    qualify status_rank = 1
)

select
    candidate_id,
    position_id,
    status as current_status
from rank_and_filter
