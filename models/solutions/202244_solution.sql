with

    src_prep as (
        select
            string_split(customer, ' ')[1][1] as order_id_prefix_1,
            string_split(customer, ' ')[-1][1] as order_id_prefix_2,
            lpad("Order Number", 6, '0') as order_id_suffix,
            "Order Number" as order_number,
            customer as customer,
            case
                when "Order Date" = ''
                then null
                else cast(strptime("Order Date", '%d/%m/%Y') as date)
            end order_date_1,
            case
                when "Date of Order" = ''
                then null
                else cast(strptime("Date of Order", '%a %d %b %Y') as date)
            end order_date_2,
            case
                when "Purchase Date" = ''
                then null
                else cast(strptime("Purchase Date", '%d/%m/%Y') as date)
            end order_date_3
        from {{ ref("src_week_202244") }}
    )

select
    concat(order_id_prefix_1, order_id_prefix_2, order_id_suffix) as order_id,
    order_number,
    customer,
    concat(order_date_1, order_date_2, order_date_3) as order_date,
from src_prep
