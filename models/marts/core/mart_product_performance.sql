-- mart_product_performance.sql
-- Grain:
--   One row per product.
--
-- Purpose:
--   Product-level performance mart used for revenue analysis,
--   sales volume tracking, category benchmarking,
--   and product ranking.
--
-- Important:
--   Revenue metrics are derived from order item transactions
--   and currently represent gross merchandise value
--   before refunds or cancellations.
--
--   total_value includes both product price and freight charges.
--
--   total_orders counts distinct orders containing the product,
--   while total_items counts total quantities sold.
--
--   revenue_rank is dynamically calculated based on
--   descending total product value.
--
-- Not Yet Included:
--   - Refund-adjusted product revenue
--   - Product profitability or margin analysis
--   - Inventory and stock availability metrics
--   - Product review and satisfaction metrics
--   - Discount and promotion attribution
--
-- Downstream Consumers:
--   - Product dashboards
--   - Revenue analysis
--   - Category performance reporting
--   - Semantic Layer product metrics

{{ config(
    materialized='table',
    tags=['mart', 'core', 'product']
) }}

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

where order_status = 'delivered'

group by 1,2