-- stg_customer.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_customer_dataset') }}
),

select * from source