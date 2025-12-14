{{ config(
    materialized='view',
    tags=['intermediate', 'dimension']
) }}

with customer_geo as (
    select
        c.customer_id,
        c.customer_zip_code,
        g.city as customer_city,
        g.state_abbrev as customer_state_abbrev,
        g.state_full as customer_state
    from {{ ref('stg_customer') }} c
    left join {{ ref('dim_geography') }} g
        on c.customer_zip_code = g.zip_code
    group by 1,2,3,4,5
)

select *
from customer_geo