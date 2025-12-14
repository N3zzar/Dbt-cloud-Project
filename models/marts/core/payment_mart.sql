{{ config(
    materialized='table',
    tags=['mart', 'payments']
) }}

select
    o.order_id,
    o.customer_id,
    o.payment_type,
    o.no_of_installments,
    o.payment_value,
    oi.product_id,
    oi.product_category_name_english,
    oi.seller_id,
    s.seller_state
from {{ ref('fact_order_items') }} oi
left join {{ ref('fact_orders') }} o
    using (order_id)
left join {{ ref('dim_seller') }} s
    on oi.seller_id = s.seller_id
where o.order_status = 'delivered'