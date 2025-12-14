{{ config(
    materialized='table',
    tags=['mart', 'sales']
) }}

with base_orders as (
    select
        o.order_id,
        o.customer_id,
        oi.seller_id,
        o.order_purchase_timestamp as purchased_date,
        o.order_approved_at as approved_date,
        o.order_delivered_to_carrier_date as delivered_carrier_date,
        o.order_delivered_customer_date as delivered_customer_date,
        o.order_estimated_delivery_date as estimated_delivery_date,
        o.order_status as order_status,
        sum(payment_value) as total_order_value,
        count(oi.order_item_id) as total_items,
        date_diff(order_delivered_customer_date, order_purchase_timestamp, day) as delivery_days,
        date_diff(order_estimated_delivery_date, order_purchase_timestamp, day) as estimated_delivery_days,
        case 
            when order_delivered_customer_date <= order_estimated_delivery_date then true 
            else false 
        end as is_delivered_on_time,
        case
            when order_delivered_customer_date > order_estimated_delivery_date then true
            else false
        end as is_delayed,
        payment_type,
        avg(o.no_of_installments) as payment_installments,
    from {{ ref('fact_orders') }} o
    left join {{ ref('fact_order_items') }} oi
        on o.order_id = oi.order_id
    group by o.order_id, o.customer_id, oi.seller_id, 
             o.order_purchase_timestamp, o.order_approved_at, 
             o.order_delivered_to_carrier_date, o.order_delivered_customer_date,
             o.order_estimated_delivery_date, o.order_status, payment_type
)

select * 
from base_orders