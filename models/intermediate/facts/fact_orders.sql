{{ config(
    materialized= 'table',
    unique_key = 'order_id',
    tags=['intermediate', 'fact'],
    schema = "analytics"
) }}

select
o.order_id,
o.customer_id,
order_status,
o.order_purchase_timestamp,
o.order_approved_at,
o.order_delivered_to_carrier_date,
o.order_delivered_customer_date,
o.order_estimated_delivery_date,
op.payment_type,
op.no_of_installments,
count(oi.order_item_id) as total_items,
count(distinct product_id) as total_product,
count(distinct oi.seller_id) as total_sellers,
sum(op.payment_value) as payment_value,
sum(oi.freight_value + oi.price) as total_order_value
from {{ ref('stg_orders') }} o 
    left join {{ ref('stg_order_items') }} oi on o.order_id = oi.order_id
    left join {{ ref('stg_order_payments') }} op on o.order_id = op.order_id
group by 1,2,3,4,5,6,7,8,9,10
