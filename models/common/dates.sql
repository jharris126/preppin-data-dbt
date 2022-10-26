with

date_data as (
    {{
        dbt_utils.date_spine(
            datepart="day",
            start_date="cast('1950-01-01' as date)",
            end_date="cast('2049-12-31' as date)"
        )
    }}
)

select
    cast(strftime(date_day, '%Y%m%d') as int) as date_integer,
    date_day as date_value,
    dayname(date_day) as day_name,
    date_trunc('month', date_day) as month_start,
    date_trunc('year', date_day) as year_start
from date_data