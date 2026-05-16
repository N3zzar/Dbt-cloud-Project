{{ config(
    materialized='table',
    tags=['mart','marketing']
) }}

with delivered_orders as (

    select *
    from {{ ref('fct_orders') }}
    where order_status = 'delivered'

),

first_orders as (

    select
        customer_id,
        min(date(order_purchase_timestamp)) as first_order_date
    from delivered_orders
    group by 1


),

customer_cohorts as (

    select
        customer_id,
        date_trunc(first_order_date, month) as cohort_month

    from first_orders

),

customer_orders as (

    select
        cc.customer_id,
        cc.cohort_month,

        date_trunc(
            date(o.order_purchase_timestamp),
            month
        ) as order_month,

        date_diff(
            date_trunc(date(o.order_purchase_timestamp), month),
            cc.cohort_month,
            month
        ) as months_since_first_order,

        o.total_order_value

    from customer_cohorts cc
    left join {{ ref('fct_orders') }} o
        on cc.customer_id = o.customer_id
)


select
    cohort_month,
    order_month,
    months_since_first_order,

    count(distinct customer_id) as customers,
    sum(total_order_value) as revenue

from customer_orders
group by 1,2,3
order by 1,2