-- stg_marketing__qualified.sql
with

    sources as (
        select * from {{ source("raw", "olist_marketing_qualified_leads_dataset") }}
    ),

    filtered as (
        select
            {{
                dbt_utils.star(
                    from = source("raw", "olist_marketing_qualified_leads_dataset"),
                    except=["landing_page_id"],
                )
            }}
        from sources
    ),

    renamed as (
        select
            mql_id,
            cast(first_contact_date as date) as first_contact_date,
            case
                when lower(trim(origin)) = 'other_publicities' then 'other'
                when origin is null or trim(origin) = 'unknown' then 'other'
                else lower(trim(origin))
            end as origin
        from filtered
    )

select *
from renamed