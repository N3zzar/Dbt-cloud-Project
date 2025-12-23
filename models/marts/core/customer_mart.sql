{{ config(tags=["mart", "customer"]) }}

with
orders_agg as (
    select
        o.customer_id,
        min(o.order_purchase_timestamp) as first_order_date,
        max(o.order_purchase_timestamp) as last_order_date,
        count(oi.order_item_id) as total_items_purchased,
        count(o.order_id) as total_orders,
        count(distinct case when o.order_status = 'delivered' then o.order_id end) as delivered_orders,
        sum(case when o.order_status = 'delivered' then payment_value else 0 end) as delivered_revenue,
        sum(case when o.order_status='cancelled' then 1 else 0 end) as cancelled_orders,
        sum(case when o.order_status='returned' then 1 else 0 end) as returned_orders
    from {{ ref("fact_orders") }} as o
    left join {{ ref('fact_order_items') }} as oi
        on o.order_id = oi.order_id
    group by o.customer_id
),

customer_details as (
    select
        c.customer_id,
        c.customer_city,
        c.customer_state,
        c.customer_zip_code
    from {{ ref("dim_customer") }} as c
)

select
    oa.customer_id,
    customer_city,
    customer_state,
    customer_zip_code,
    first_order_date,
    last_order_date,
    total_items_purchased,
    total_orders,
    delivered_orders,
    delivered_revenue,
    cancelled_orders,
    returned_orders,
    case when oa.delivered_orders = 0 then 0
        else oa.delivered_revenue / oa.delivered_orders
    end as avg_order_value
from customer_details as cd
left join orders_agg as oa
    on cd.customer_id = oa.customer_id

