-- stg_closed_deals.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_closed_deals_dataset') }}
),

select * from source