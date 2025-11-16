-- stg_marketing__qualified.sql

with 

sources as (
    select *
    from {{ source ('raw', 'olist_marketing_qualified_leads_dataset') }}
),

filtered as (
    select
        {{ dbt_utils.star(from = source ('raw', 'olist_marketing_qualified_leads_dataset'), except=["landing_page_id"]) }}
    from sources
)
select * from filtered