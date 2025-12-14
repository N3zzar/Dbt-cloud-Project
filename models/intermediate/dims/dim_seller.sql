{{ config(
    materialized='view',
    tags=['intermediate', 'dimension']
) }}

with seller_geo as (
    select
        s.seller_id,
        s.seller_zip_code,
        g.city as seller_city,
        g.state_abbrev as seller_state_abbrev,
        g.state_full as seller_state
    from {{ ref('stg_sellers') }} s
    left join {{ ref('dim_geography') }} g
        on s.seller_zip_code = g.zip_code
    group by 1,2,3,4,5
)

select *
from seller_geo
