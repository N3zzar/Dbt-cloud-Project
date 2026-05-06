-- stg_product__catgory__name.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_product_category_name_translation') }}
)
,

renamed as (
    select 
        string_field_0 as product_category_name,
        string_field_1 as product_category_name_english
    from source
    where string_field_0 != 'product_category_name'   -- remove header row

)
    
select * from renamed