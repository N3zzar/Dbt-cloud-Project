{{ config(materialized="table", tags=["mart", "customer"]) }}

with 
    orders_agg as (
        select
            o.customer_id,
            min(o.order_purchase_timestamp) as first_order_date,
            max(o.order_purchase_timestamp) as last_order_date,
            count(o.order_id) as total_orders,
            count(oi.order_item_id) as total_items_purchased,
            sum(payment_value) as total_revenue
        from {{ ref("fact_orders") }} o
        left join {{ ref('fact_order_items') }} oi
        on o.order_id = oi.order_id
        where o.order_status = 'delivered'
        group by o.customer_id
    ),

    customer_details as (
        select
            c.customer_id,
            c.customer_city,
            c.customer_state,
            c.customer_zip_code
        from {{ ref("dim_customer") }} c
    )

select
    *,
    date_diff(DATE(last_order_date), DATE(oa.first_order_date), day) as customer_lifetime_days,
    case when oa.total_orders > 1 then true else false end as is_repeat_customer,
    total_revenue / nullif(total_orders,0) as avg_order_value
from orders_agg oa