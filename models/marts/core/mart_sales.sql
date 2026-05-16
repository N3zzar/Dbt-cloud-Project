{{ config(
    materialized='table',
    tags=['mart', 'sales']
) }}

with base_orders as (

    select
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        date(o.order_purchase_timestamp) as purchase_date,

        o.order_status,

        o.total_items,
        o.total_order_value,

        o.delivery_days,

        o.estimated_delivery_days,

        o.is_delivered_on_time,

        o.is_delayed

    from {{ ref('fct_orders') }} o

    where o.order_status = 'delivered'

),

final as (

    select
        bo.*,

        dd.day,
        dd.day_of_week,
        dd.day_name,
        dd.is_weekend,
        dd.week_number,
        dd.month,
        dd.month_name,
        dd.quarter,
        dd.year

    from base_orders bo
    left join {{ ref('dim_date') }} dd
        on bo.purchase_date = dd.date_day

)

select *
from final