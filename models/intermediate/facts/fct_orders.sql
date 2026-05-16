-- fct_orders.sql
-- Grain: One row per order_id
-- Path: Olist
-- Purpose: 

-- Powers Downstream

{{ config(
    materialized= 'table',
    unique_key = 'order_id',
    tags=['intermediate', 'fact'],
    schema = "analytics"
) }}

with items as (
    select
        order_id,
        count(order_item_id)as total_items,
        count(distinct product_id) as total_products,
        count(distinct seller_id) as total_sellers,
        sum(price) as items_total_price,
        sum(freight_value) as items_total_freight
    from {{ ref('stg__order_items') }}
    group by 1
)

, payments as (
    select
        order_id,
        coalesce(sum(payment_value), 0) as total_payment_value,
        coalesce(count(*), 0) as total_payment_records
    from {{ ref('stg__order_payments') }}
    group by 1
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_to_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    case 
        when o.order_delivered_customer_date is not null 
        then date_diff(o.order_estimated_delivery_date, o.order_delivered_customer_date, day) end as delivery_delay_days,

    date_diff(o.order_delivered_customer_date, o.order_purchase_timestamp, day) as delivery_days,

    date_diff(o.order_estimated_delivery_date, o.order_purchase_timestamp, day) as estimated_delivery_days,

    case
        when o.order_delivered_customer_date
            <= o.order_estimated_delivery_date
        then true
        else false
    end as is_delivered_on_time,

    case
        when o.order_delivered_customer_date
                > o.order_estimated_delivery_date
        then true
        else false
    end as is_delayed,

    case
        when coalesce(i.total_items, 0) = 0 then 'no items'
        when i.total_items = 1 then 'single item'
        when i.total_items <= 5 then 'small order'
        when i.total_items <= 12 then 'medium order'
        else 'large order'
    end as order_size_bucket,

    coalesce(i.total_items, 0) as total_items,
    coalesce(i.total_products, 0) as total_products,
    coalesce(i.total_sellers, 0) as total_sellers,

    p.total_payment_records,
    p.total_payment_value,

    coalesce(i.items_total_price + i.items_total_freight, 0) as total_order_value

from {{ ref('stg__orders') }} o
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id