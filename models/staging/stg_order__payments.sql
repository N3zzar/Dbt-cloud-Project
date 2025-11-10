-- stg_order__payments.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_order_payments_dataset') }}
)

select * from source