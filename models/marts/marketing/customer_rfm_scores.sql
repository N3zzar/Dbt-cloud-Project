{{ config(
    tags=['mart','marketing']
) }}

with customer_orders as (
    select
        o.customer_id,
        min(order_purchase_timestamp) as first_order_date,
        max(order_purchase_timestamp) as last_order_date,
        count(distinct o.order_id) as frequency,
        sum(payment_value) as monetary
    from {{ ref('fact_orders') }} o
    left join {{ ref('fact_order_items') }} oi
        on o.order_id = oi.order_id
    group by customer_id
)

select
    customer_id,
    first_order_date,
    last_order_date,
    frequency,
    monetary,
    date_diff({{ get_current_date() }}, date(last_order_date), month) as recency_months
from customer_orders