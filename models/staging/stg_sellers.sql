-- stg_sellers.sql

with 

seller as (
    select *
    from {{ source ('raw', 'olist_sellers_dataset') }}
)

select * from seller