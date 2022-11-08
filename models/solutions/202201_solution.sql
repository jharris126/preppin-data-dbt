with

source_data as (
    select
        "id" as id,
        "pupil first name" as pupil_first_name,
        "pupil last name" as pupil_last_name,
        "gender" as gender,
        cast(strptime("Date of Birth", '%-m/%-d/%Y') as date) as date_of_birth,
        "Parental Contact Name_1" as parental_contact_name_1,
        "Parental Contact Name_2" as parental_contact_name_2,
        "Preferred Contact Employer" as preferred_contact_employer,
        "Parental Contact" as parental_contact
    from {{ ref('src_week_202201') }}
)

select
    cast(
        ceil(date_diff('month', date_of_birth, cast('2014-09-01' as date))/12.0) + 1 as int
    ) as academic_year,
    concat(pupil_last_name, ', ', pupil_first_name) as pupils_name,
    case
        when parental_contact = 1
            then concat(pupil_last_name, ', ', parental_contact_name_1)
        else concat(pupil_last_name, ', ', parental_contact_name_2)
    end as parental_contact_full_name,
    case
        when parental_contact = 1
            then concat(parental_contact_name_1, '.', pupil_last_name, '@', preferred_contact_employer, '.com')
        else concat(parental_contact_name_2, '.', pupil_last_name, '@', preferred_contact_employer, '.com')
    end as parental_contact_email_address
from source_data
