-- fct_order_items.sql
-- Grain:
--   One row per order item.
--
-- Purpose:
--   Item-level transactional fact table used for
--   product performance, revenue composition,
--   seller analytics, and category analysis.
--
-- Important:
--   total_item_value = price + freight_value.
--
--   Revenue metrics derived from this model represent
--   gross merchandise value before refunds or adjustments.
--
--   Multiple order items can belong to the same order.
--   Aggregating order-level dimensions directly from this model
--   may lead to duplicated counts if not handled carefully.
--
-- Not Yet Included:
--   - Refund-adjusted item revenue
--   - Product margin calculations
--   - Discount attribution
--   - Inventory and stock metrics
--
-- Downstream Consumers:
--   - mart_product_performance
--   - Semantic Layer (order_items)
--   - Product dashboards
--   - Revenue dashboards


{{ config(materialized="table", tags=["intermediate", "fact"], schema = "analytics") }}


select 
    i.order_id,
    i.order_item_id,
    i.product_id,
    p.product_category_name_english,
    i.seller_id,
    i.price,
    i.freight_value,
    i.price + i.freight_value as total_item_value,
    o.order_status,
    o.order_purchase_timestamp


from {{ ref("stg__order_items") }} i

left join {{ ref("dim_product") }} p
    on i.product_id = p.product_id

left join {{ ref('fct_orders') }} o
    on i.order_id = o.order_id