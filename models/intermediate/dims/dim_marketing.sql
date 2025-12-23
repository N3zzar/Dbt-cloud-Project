{{ config(
    tags=['intermediate', 'dimension']
) }}

select
    d.mql_id,
    d.seller_id,
    m.first_contact_date,
    d.won_date,
    m.origin,
    d.business_segment,
    d.lead_category 
from {{ ref('stg_closed_deals') }} d
left join {{ ref('stg_marketing_qualified_leads') }} m
    on d.mql_id = m.mql_id