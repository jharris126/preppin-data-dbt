select
    bank,
    online_or_in_person,
    transaction_date,
    sum(value) as value
from {{ ref("int_week_202301") }}
group by
    bank,
    online_or_in_person,
    transaction_date
