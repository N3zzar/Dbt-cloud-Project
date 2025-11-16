-- models/staging/stg_customer.sql

with raw_source as (
    select *
    from {{ source('raw', 'olist_customers_dataset') }}
),

filtered as (
    select
        {{ dbt_utils.star(from=source('raw', 'olist_customers_dataset'), except=["customer_unique_id", "customer_city", "customer_state"]) }}
    from raw_source
),

renamed as (
    select
        customer_id,
        customer_zip_code_prefix
    from filtered
)

select *
from renamed