{{ config(materialized="table", tags=["mart", "customer"]) }}

with orders_agg as (

    select
        customer_id,
        date(min(order_purchase_timestamp)) as first_order_date,
        date(max(order_purchase_timestamp)) as last_order_date,
        sum(total_items) as total_items_purchased,
        count(distinct order_id) as total_orders,
        sum(total_order_value) as total_revenue

    from {{ ref("fct_orders") }}

    where order_status = 'delivered'

    group by 1

),

customer_details as (

    select
        customer_id,
        customer_city,
        customer_state,
        customer_zip_code

    from {{ ref("dim_customer") }}

)

select
    oa.customer_id,
    cd.customer_city,
    cd.customer_state,
    cd.customer_zip_code,

    oa.first_order_date,
    oa.last_order_date,
    oa.total_items_purchased,
    oa.total_orders,
    oa.total_revenue,

    date_diff(
        date(oa.last_order_date),
        date(oa.first_order_date),
        day
    ) as customer_lifetime_days,

    case
        when oa.total_orders > 1 then true
        else false
    end as is_repeat_customer,

    oa.total_revenue / nullif(oa.total_orders, 0) as avg_order_value

from orders_agg oa
left join customer_details cd
    on oa.customer_id = cd.customer_id