with

prime_ministers as (
    select
        case "Prime Ministers"
            when 'Winston Churchill' then 'Sir Winston Churchill'
            else "Prime Ministers"
        end as prime_minister,
        cast(strptime(replace(trim(string_split("Duration", '-')[1]), 'th', ''), '%-d %B %Y') as date) as term_begin,
        case
            when trim(string_split("Duration", '-')[2]) = 'Present' then today()
        else cast(strptime(replace(trim(string_split("Duration", '-')[2]), 'th', ''), '%-d %B %Y') as date)
        end as term_end
    from {{ ref("src_week_202247_pms") }}
),

prime_minister_days as (
    select
        prime_ministers.prime_minister,
        prime_ministers.term_begin,
        prime_ministers.term_end,
        dates.date_value,
        row_number() over(partition by dates.date_value order by prime_ministers.term_begin) as pm_day_order
    from dates
    inner join prime_ministers
        on dates.date_value between prime_ministers.term_begin and prime_ministers.term_end
    qualify pm_day_order = 1
    
),

managers as (
    select
        string_split("Name", '[')[1] as manager,
        case
            when "row_num" < 9 then cast(strptime("From", '%-d-%b-%y') as date) - interval 100 year
            else cast(strptime("From", '%-d-%b-%y') as date)
        end as term_begin,
        case
            when "To" = 'Present' then today()
            when "row_num" < 8 then cast(strptime("To", '%-d-%b-%y') as date) - interval 100 year
            when string_split("Name", '[')[1] = 'Bobby Gould' then '1981-05-28'
            else cast(strptime("To", '%-d-%b-%y') as date)
        end as term_end
    from {{ ref("src_week_202247_managers") }}
),

manager_days as (
    select
        managers.manager,
        managers.term_begin,
        dates.date_value,
        row_number() over(partition by dates.date_value order by managers.term_begin) as manager_day_order
    from dates
    inner join managers
        on dates.date_value between managers.term_begin and managers.term_end
    qualify manager_day_order = 1
),

matches as (
    select
        cast(
            strptime(
                replace(replace(replace(replace("Date", 'st', ''), 'nd', ''), 'rd', ''), 'th', ''),
                '%-d %b %Y'
            ) as date
        ) as match_date,
        string_split("Result", 'Match ')[2] as match_result
    from {{ ref("src_week_202247_matches") }}
    where "Comp" in ('League', 'League Cup', 'F.A. Cup', 'Europe')
),

match_days as (
    select
        match_date,
        sum(1) as matches,
        sum(case when match_result = 'Won' then 1 else 0 end) as wins,
        sum(case when match_result = 'Drawn' then 1 else 0 end) as draws,
        sum(case when match_result = 'Lost' then 1 else 0 end) as losses
    from matches
    group by match_date
),

combined as (
    select
        prime_minister_days.date_value,
        prime_minister_days.prime_minister,
        prime_minister_days.term_begin,
        prime_minister_days.term_end,
        manager_days.manager,
        manager_days.term_begin as manager_term_begin,
        match_days.*
    from prime_minister_days
    left join manager_days
        on prime_minister_days.date_value = manager_days.date_value
    left join match_days
        on prime_minister_days.date_value = match_days.match_date
)

select
    prime_minister,
    term_begin,
    term_end,
    coalesce(count(distinct manager_term_begin), 0) as managers,
    coalesce(sum(matches), 0) as matches,
    coalesce(sum(wins), 0) as matches_won,
    coalesce(sum(draws), 0) as matches_drawn,
    coalesce(sum(losses), 0) as matches_lost,
    cast(sum(wins)*1.000/sum(matches) as numeric(8, 2)) as win_percent
from combined
group by prime_minister, term_begin, term_end
