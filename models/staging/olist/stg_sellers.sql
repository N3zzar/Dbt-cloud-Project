-- stg_sellers.sql
{{ config(tags=["staging", "olist"]) }}

with 

source as (
    select *
    from {{ source ('raw', 'olist_sellers_dataset') }}
),

final as (
    select seller_id,
           trim(cast(seller_zip_code_prefix as string)) as seller_zip_code
    from source
)

select *
from final