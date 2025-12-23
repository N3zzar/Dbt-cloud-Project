{{ config(
    tags=['mart','marketing']
) }}

with first_orders as (
    select
        customer_id,
        cast(order_purchase_timestamp as date) first_order_month,
        date_trunc(cast(order_purchase_timestamp as DATE), month) as cohort_month
    from {{ ref('fact_orders') }}
)

select
    fo.cohort_month,
    date_trunc(cast(o.order_purchase_timestamp as DATE), month) as order_month,
    count(distinct o.customer_id) as num_customers,
    sum(o.payment_value) as revenue
from first_orders as fo
left join {{ ref('fact_orders') }} as o
    on fo.customer_id = o.customer_id
group by fo.cohort_month, order_month
order by cohort_month, order_month
