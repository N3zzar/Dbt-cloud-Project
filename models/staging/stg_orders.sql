-- stg_orders.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_orders_dataset') }}
)

select * from source