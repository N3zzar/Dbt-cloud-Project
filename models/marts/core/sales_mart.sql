{{ config(
    tags=['mart', 'sales']
) }}

/* with base_orders as (
    select
        o.order_id,
        o.customer_id,
        oi.seller_id,
        o.order_purchase_timestamp as purchased_date,
        o.order_approved_at as approved_date,
        o.order_delivered_to_carrier_date as delivered_carrier_date,
        o.order_delivered_customer_date as delivered_customer_date,
        o.order_estimated_delivery_date as estimated_delivery_date,
        o.order_status,
        payment_type,
        cast(avg(o.no_of_installments) as int) as payment_installments,
        sum(payment_value) as total_order_value,
        count(oi.order_item_id) as total_items,
        date_diff(
            order_delivered_customer_date, order_purchase_timestamp, day
        ) as delivery_days,
        date_diff(
            order_estimated_delivery_date, order_purchase_timestamp, day
        ) as estimated_delivery_days,
        coalesce (order_delivered_customer_date
        <= order_estimated_delivery_date,
        false) as is_delivered_on_time,
        coalesce (order_delivered_customer_date > order_estimated_delivery_date,
        false) as is_delayed
    from {{ ref('fact_orders') }} as o
    left join {{ ref('fact_order_items') }} as oi
        on o.order_id = oi.order_id
    where o.order_status = 'delivered'
    group by
        o.order_id, o.customer_id, oi.seller_id,
        o.order_purchase_timestamp, o.order_approved_at,
        o.order_delivered_to_carrier_date, o.order_delivered_customer_date,
        o.order_estimated_delivery_date, o.order_status, payment_type
)

select *
from base_orders

*/

with order_items_agg as (
    select
        order_id,
        sum(freight_value + price) as total_order_value,
        count(order_item_id) as total_items
    from {{ ref('fact_order_items') }}
    group by order_id
),

base_orders as (
    select
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp as purchased_date,
        o.order_approved_at as approved_date,
        o.order_delivered_to_carrier_date as delivered_carrier_date,
        o.order_delivered_customer_date as delivered_customer_date,
        o.order_estimated_delivery_date as estimated_delivery_date,
        o.order_status,
        o.payment_type,
        o.no_of_installments as payment_installments,
        oi.total_order_value,
        oi.total_items,
        date_diff(o.order_delivered_customer_date, o.order_purchase_timestamp, day) as delivery_days,
        date_diff(o.order_estimated_delivery_date, o.order_purchase_timestamp, day) as estimated_delivery_days,
        coalesce(o.order_delivered_customer_date <= o.order_estimated_delivery_date, false) as is_delivered_on_time,
        coalesce(o.order_delivered_customer_date > o.order_estimated_delivery_date, false) as is_delayed
    from {{ ref('fact_orders') }} as o
    left join order_items_agg as oi
        on o.order_id = oi.order_id
    where o.order_status = 'delivered'
)

select *
from base_orders