{{ config(
    materialized='table',
    tags=['mart','marketing']
) }}

with first_orders as (
    select
        customer_id,
        date_trunc(order_purchase_timestamp, month) as cohort_month,
        order_purchase_timestamp
    from {{ ref('fact_orders') }}
)

select
    fo.cohort_month,
    date_trunc(o.order_purchase_timestamp, month) as order_month,
    count(distinct o.customer_id) as num_customers,
    sum(o.payment_value) as revenue
from first_orders fo
left join {{ ref('fact_orders') }} o
    on fo.customer_id = o.customer_id
group by fo.cohort_month, order_month
order by cohort_month, order_month