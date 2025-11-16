-- stg_product.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_products_dataset') }}
),

final as (
    select product_id,
           product_category_name
    from source
)

select * from final