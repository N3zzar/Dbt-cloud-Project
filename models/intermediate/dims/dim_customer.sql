{{ config(
    tags=['intermediate', 'dimension']
) }}

with customer_geo as (
    select
        c.customer_id,
        c.customer_zip_code,
        coalesce(g.city, 'unknown') as customer_city,
        coalesce(g.state_abbrev, 'unknown') as customer_state_abbrev,
        coalesce(g.state_full, 'unknown') as customer_state
    from {{ ref('stg__customer') }} c
    left join {{ ref('dim_geography') }} g
        on c.customer_zip_code = g.zip_code
    group by 1,2,3,4,5
)

select *
from customer_geo