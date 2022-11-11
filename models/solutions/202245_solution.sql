with

    upv as (

        {{
            dbt_utils.unpivot(
                ref("src_week_202245"), cast_to="varchar", exclude=["store"]
            )
        }}

    ),

    prep as (
        select
            store,
            cast(
                strptime(
                    concat(string_split(field_name, '_')[1], '/01/2022'), '%b/%d/%Y'
                ) as date
            ) as date,
            string_split(field_name, '_')[2] as category,
            value
        from upv
    )

select
    store,
    date,
    cast(max(case when category = 'sales' then value end) as bigint) as sales,
    cast(max(case when category = 'profit' then value end) as bigint) as profit
from prep
group by store, date
