-- stg_order_reviews.sql

with 

source as (
    select *
    from {{ ref ('olist_order_reviews_dataset') }}
)

select * from source