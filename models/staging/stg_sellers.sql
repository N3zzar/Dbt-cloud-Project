-- stg_sellers.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_sellers_dataset.csv') }}
),

select * from source