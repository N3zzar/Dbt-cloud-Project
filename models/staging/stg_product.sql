-- stg_product.sql

with 

product as (
    select *
    from {{ source ('raw', 'olist_products_dataset') }}
)

select * from product