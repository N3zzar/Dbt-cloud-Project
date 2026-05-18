{{ config(
    tags=['intermediate', 'dimension']
) }}

select
    p.product_id,
    pc.product_category_name_english,
    pc.product_category_name,
    avg(oi.price) as price
from {{ ref('stg__product') }} p
left join {{ ref('stg__product_category_name') }} pc
    on p.product_category_name = pc.product_category_name
left join {{ ref('stg__order_items') }} oi
    on p.product_id = oi.product_id
group by 1,2,3
