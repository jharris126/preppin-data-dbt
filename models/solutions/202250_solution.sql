with status_sorted as (
    select
        candidate_id,
        position_id,
        status,
        row_number() over(partition by candidate_id, position_id order by ts desc) as status_order
    from {{ ref("202249_solution_1") }}
),

withdrawals as (
    select
        prior_status.status as status_before_withdrawal,
        count(*) as withdrawals
    from status_sorted as current_status
    left join status_sorted as prior_status
        on current_status.candidate_id = prior_status.candidate_id
            and current_status.position_id = prior_status.position_id
            and prior_status.status_order = 2
    where current_status.status_order = 1
        and current_status.status = 'Candidate Withdrew'
    group by prior_status.status
),

status_history as (
    select
        status,
        count(*) as total_in_status
    from status_sorted
    group by status
)

select
    status_history.status as status_before_withdrawal,
    coalesce(withdrawals.withdrawals, 0) as withdrawals,
    status_history.total_in_status,
    round(coalesce(withdrawals.withdrawals, 0) * 1.0/status_history.total_in_status * 100, 1) as pct_withdrawn
from status_history
left join withdrawals
    on status_history.status = withdrawals.status_before_withdrawal
