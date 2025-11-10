-- stg_marketing__qualified.sql

with 

sources as (
    select *
    from {{ source ('raw', 'olist_marketing_qualified_leads_dataset') }}
)

select * from sources