with add_level as (
    select
        *,
        array_pop_back(array_pop_front(string_split(team_hierarchy, '|'))) as team_hierarchy_list,
        array_pop_back(array_pop_front(string_split(dependent_team_ids, '|')))[1] as dependent_team_id,
        array_length(array_pop_back(array_pop_front(string_split(employee_id_hierarchy, '|')))) as hierarchy_level
    from {{ ref("src_week_202252_employees") }}
),

subdepts as (
    select distinct
        case
            dense_rank() over(
                partition by
                    department
                order by
                    hierarchy_level
            ) 
        when 2 then dependent_team_id
        else null
        end as subdept_team_id
    from add_level
    where department != 'Executives'
        and title not like '%Administrator%'
),

population as (
    select
        add_level.*,
        coalesce(subdepts_team.subdept_team_id, subdepts_hierarchy.subdept_team_id) as subdept_team_id
    from add_level
    left join subdepts subdepts_team
        on add_level.dependent_team_id = subdepts_team.subdept_team_id
    left join subdepts subdepts_hierarchy
        on list_contains(add_level.team_hierarchy_list, subdepts_hierarchy.subdept_team_id)
)

select
    population.position_id,
    population.employee_id,
    population.title,
    population.department,
    population.supervisor_id,
    population.team_id,
    population.direct_reports,
    population.team_name,
    population.team_hierarchy,
    population.employee_id_hierarchy,
    population.dependent_team_ids,
    population.hierarchy_level,
    population.subdept_team_id,
    teams.team_name as subdept_name
from population
left join {{ ref("src_week_202252_teams") }} teams
    on population.subdept_team_id = teams.team_id
