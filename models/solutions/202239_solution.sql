with

source_data as (
    select
        "ï»¿Record ID" as record_id,
        case trim("Employee")
            when '' then null
            else "Employee"
        end as employee,
        "Work Level" as work_level,
        "Stage" as stage,
        cast(strptime("Date", '%d/%m/%Y') as date) as date
    from {{ source('preppin_data_input_files', 'src_week_202239') }}
),

fill_grouper as (
    select
        record_id,
        employee,
        work_level,
        stage,
        date,
        count(employee) over(order by record_id) as fill_group_employee,
        count(work_level) over(order by record_id) as fill_group_work_level
    from source_data
)

select
    record_id,
    first_value(employee) over(partition by fill_group_employee order by record_id) as employee,
    first_value(work_level) over(partition by fill_group_work_level order by record_id) as work_level,
    stage,
    date
from fill_grouper