-- stg_closed_deals.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_closed_deals_dataset') }}
),

filtered as (
    select 
        mql_id,
        seller_id,
        won_date,
        business_segment
    from source
)

select * from filtered