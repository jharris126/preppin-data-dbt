with

data_to_list as (
    select
        string_split("Work Experience", ', ') as data_list
    from {{ ref("src_week_202251") }}
),

structured_data as (
    select
        replace(data_list[1], 'Application Date: ', '') as application_date,
        replace(data_list[2], 'Work Experience: ', '') as work_experience,
        replace(data_list[3], 'Supervised: ', '') as supervised,
        string_split(replace(data_list[4], 'Industry Experience: ', ''), ' ') as industry_experience
    from data_to_list
    where data_list[2] is not null
),

prep_and_cast as (
    select
        cast(strptime(application_date, '%B %Y') + interval 1 month - interval 1 day as date) as application_month,
        work_experience,
        supervised,
        industry_experience[1] as industry_experience,
        cast(replace(replace(industry_experience[2], '(', ''), ')', '') as int) as candidate_count
    from structured_data
),

summarized as (
    select
        application_month,
        sum(candidate_count) as total_candidates,
        sum(
            case
                when
                    work_experience != '0-3 years' and
                    supervised = '11-20' and
                    industry_experience = 'Yes' then 1
                else 0
            end
        ) as preferred_flag
    from prep_and_cast
    group by application_month
)

select
    application_month,
    cast(total_candidates as int) as total_candidates,
    cast(preferred_flag as int) as candidates_with_preferred_qualifications,
    cast(
        preferred_flag * 1.0 /
        total_candidates * 100 as numeric(8, 1)
    ) as percent_preferred_of_total_candidates
from summarized
