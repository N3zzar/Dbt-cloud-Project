-- stg_order__payments.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_order_payments_dataset') }}
),


filtered as (
    select {{ dbt_utils.star(from=source('raw', 'olist_order_payments_dataset'), except=["payment_sequential"]) }}
    from source
),

renamed as(
    select 
        order_id,
        lower(trim(payment_type)) as payment_type,
        cast(payment_installments as int64) as no_of_installments,
        cast(payment_value as decimal) as payment_value
    from filtered
)

select *
from renamed