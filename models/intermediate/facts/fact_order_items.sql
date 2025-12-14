{{ config(materialized="view", tags=["intermediate", "fact"], schema = "analytics") }}

select
    i.order_id,
    i.order_item_id,
    i.product_id,
    p.product_category_name_english,
    i.seller_id,
    i.price,
    i.freight_value
from {{ ref("stg_order_items") }} i
left join {{ ref("dim_product") }} p on i.product_id = p.product_id