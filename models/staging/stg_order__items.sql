-- stg_order__items.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_order_items_dataset') }}
),

select * from source