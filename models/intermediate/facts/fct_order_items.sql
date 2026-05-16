-- fct_order_items.sql
-- Grain: one row per order item fact table
-- Path: 
-- Purpose: 

-- Powers Downstream


{{ config(materialized="view", tags=["intermediate", "fact"], schema = "cleaned") }}


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