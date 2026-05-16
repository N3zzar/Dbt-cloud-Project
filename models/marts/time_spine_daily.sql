{{
    config(
        materialized='table'
    )
}}

with spine as (

    {{
        dbt.date_spine(
            datepart="day",
            start_date="cast('2020-01-01' as date)",
            end_date="cast('2030-01-01' as date)"
        )
    }}

)

select
    cast(date_day as date) as date_day
from spine
where date_day >= date_sub(current_date(), interval 5 year)
  and date_day < date_add(current_date(), interval 30 day)