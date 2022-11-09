with

    source_data as (
        select
            "Player" as player, "Session" as session, "Date" as date, "Score" as score
        from {{ ref("src_week_202242") }}
    ),

    session_dates as (
        select date_value
        from {{ ref("dates") }}
        where
            dates.date_value between (select min(date) from source_data) and (
                select max(date) from source_data
            )
            and day_name not in ('Saturday', 'Sunday')
    ),

    players as (select distinct player from source_data),

    sessions as (select distinct session from source_data),

    player_sessions as (
        select
            players.player, sessions.session, session_dates.date_value as session_date
        from players
        cross join sessions
        cross join session_dates
    ),

    combined as (
        select
            player_sessions.player,
            player_sessions.session,
            player_sessions.session_date,
            source_data.score
        from player_sessions
        left join
            source_data
            on player_sessions.player = source_data.player
            and player_sessions.session = source_data.session
            and player_sessions.session_date = source_data.date
    ),

    fill_grouper as (
        select
            player,
            session,
            session_date,
            score,
            count(score) over (
                partition by player, session order by session_date
            ) as fill_group
        from combined
    )

select
    player,
    session,
    session_date,
    first_value(score) over (
        partition by player, session, fill_group order by session_date
    ) as score,
    case when score is null then 'Carried Over' else 'Actual' end as flag
from fill_grouper
