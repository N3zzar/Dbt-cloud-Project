-- stg_closed_deals.sql
with

source as (select * from {{ source("raw", "olist_closed_deals_dataset") }}),

filtered as (
    select
        mql_id,
        seller_id,
        cast(won_date as timestamp) as won_date,
        {{ unknown_to_other ('lead_type', 'lead_category') }},
        {{ unknown_to_other ( 'business_segment', 'business_segment') }}
    from source
)

select *
from filtered
