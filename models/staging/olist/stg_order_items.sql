-- stg_order__items.sql
{{ config(tags=["staging", "olist"]) }}

with 

source as (
    select *
    from {{ source ('raw', 'olist_order_items_dataset') }}
),

renamed as (
    select 
       order_id,
       order_item_id,
       product_id,
       seller_id,
       cast(price as numeric) as price,
       cast(freight_value as numeric) as freight_value
    from source
)

select * from renamed