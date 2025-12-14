-- stg_product__catgory__name.sql

with 

source as (
    select *
    from {{ source ('raw', 'product_category_name_translation') }}
)
,

renamed as (
    select 
        lower(trim(product_category_name)) as product_category_name,
        lower(trim(product_category_name_english)) as product_category_name_english
    from source
)
    
select * from renamed