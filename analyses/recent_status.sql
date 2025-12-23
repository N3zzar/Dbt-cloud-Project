with normalized_orders as (

    select 
        order_id,
        customer_id,
        order_status,
        {{ cast_to_timestamp({
            'order_purchase_timestamp': 'order_purchase_timestamp',
            'order_approved_at': 'order_approved_at',
            'order_delivered_to_carrier_date': 'order_delivered_to_carrier_date',
            'order_delivered_customer_date': 'order_delivered_customer_date',
            'order_estimated_delivery_date': 'order_estimated_delivery_date'
        }) }},
        case
            when lower(trim(order_status)) in ('created','processing') then 1
            when lower(trim(order_status)) = 'approved' then 2
            when lower(trim(order_status)) = 'invoiced' then 3
            when lower(trim(order_status)) = 'shipped' then 4
            when lower(trim(order_status)) = 'delivered' then 5
            when lower(trim(order_status)) in ('canceled','unavailable') then 6
            else 0
        end as status_priority
    from {{ ref('stg_orders') }}

),

ranked_orders as (
    select
        *,
        row_number() over (
            partition by order_id
            order by status_priority desc, order_purchase_timestamp desc
        ) as row_number
    from normalized_orders
)

select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_to_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
from ranked_orders
order by order_id