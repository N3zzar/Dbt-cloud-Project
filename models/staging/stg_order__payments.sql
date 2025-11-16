-- stg_order__payments.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_order_payments_dataset') }}
),


filtered as (
    select {{ dbt_utils.star(from=source('raw', 'olist_order_payments_dataset'), except=["payment_sequential"]) }}
    from source
)

select *
from filtered