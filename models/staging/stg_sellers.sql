-- stg_sellers.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_sellers_dataset') }}
),

final as (
    select seller_id,
           seller_zip_code_prefix as seller_zip_code
    from source
)

select *
from final