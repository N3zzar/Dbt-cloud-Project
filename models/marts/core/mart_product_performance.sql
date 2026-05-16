select
    product_id,
    product_category_name_english,

    count(distinct order_id) as total_orders,
    count(*) as total_items,

    sum(price) as product_revenue,
    sum(freight_value) as total_freight,

    sum(price + freight_value) as total_value,

    avg(price) as avg_price,

    rank() over (
        order by sum(price + freight_value) desc
    ) as revenue_rank

from {{ ref('fct_order_items') }}

group by 1,2