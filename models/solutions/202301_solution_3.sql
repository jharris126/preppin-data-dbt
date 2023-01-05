select
    bank,
    customer_code,
    sum(value) as value
from {{ ref("int_week_202301") }}
group by
    bank,
    customer_code
