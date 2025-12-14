{{ config(
    materialized='view',
    tags=['intermediate', 'dimension']
) }}

select
    p.product_id,
    pc.product_category_name_english,
    pc.product_category_name,
    oi.price
from {{ ref('stg_product') }} p
left join {{ ref('stg_product_category') }} pc
    on p.product_category_name = pc.product_category_name
left join {{ ref('stg_order_items') }} oi
    on p.product_id = oi.product_id
group by 1,2,3,4
