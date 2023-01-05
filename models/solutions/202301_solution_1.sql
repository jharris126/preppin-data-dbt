select
    bank,
    sum(value) as value
from {{ ref("int_week_202301") }}
group by bank
