{{ config(
    materialized='table',
    tags=['mart', 'core', 'sales']
) }}

-- Grain: one row per delivered order.
-- Purpose: compact revenue mart for the Lightdash revenue dashboard.
-- Dashboard metrics: total customers, total revenue, revenue per customer.

with delivered_orders as (

    select
        cast(order_id as string) as order_id,
        cast(customer_id as string) as customer_id,
        cast(order_value as float64) as order_value,
        cast(extract(month from order_purchase_timestamp) as int64) as month,
        cast(extract(year from order_purchase_timestamp) as int64) as year
    from {{ ref('fct_orders') }}
    where order_status = 'delivered'

)

select
    order_id,
    customer_id,
    order_value as total_order_value,
    month,
    year
from delivered_orders