select
    "Transaction Code" as transaction_code,
    string_split("Transaction Code", '-')[1] as bank,
    case "Online or In-Person"
        when 1 then 'Online'
        when 2 then 'In-Person'
    end as online_or_in_person,
    dayname(
        strptime(
            string_split("Transaction Date", ' ')[1],
            '%d/%m/%Y'
        )
    ) as transaction_date,
    "Value" as value,
    "Customer Code" as customer_code
from {{ ref("src_week_202301") }}
