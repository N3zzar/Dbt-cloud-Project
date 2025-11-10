-- stg_product.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_product_dataset') }}
),

select * from source