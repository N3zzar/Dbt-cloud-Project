-- Grain: One row per converted MQL / Closed deals

{{ config(
    materialized='table',
    tags=['intermediate', 'dimension']
) }}

select
    d.mql_id,
    d.seller_id,
    m.first_contact_date,
    d.won_date,

    date_diff(
        d.won_date, 
        m.first_contact_date,
        day
    ) as days_to_close,

    m.origin,
    d.business_segment,
    d.lead_category 
from {{ ref('stg__closed_deals') }} d
left join {{ ref('stg__marketing_qualified_leads') }} m
    on d.mql_id = m.mql_id