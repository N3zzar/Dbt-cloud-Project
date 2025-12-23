{{ config(
    tags=['intermediate', 'dimension']
) }}

select
    p.product_id,
    pc.product_category_name_english,
    pc.product_category_name,
from {{ ref('stg_product') }} p
left join {{ ref('stg_product_category') }} pc
    on p.product_category_name = pc.product_category_name
group by 1,2,3