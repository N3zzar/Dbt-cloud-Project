-- fct_marketing.sql
-- Grain:
--   One row per marketing-qualified lead associated
--   with a closed deal.
--
-- Purpose:
--   Marketing and sales conversion fact table used for
--   acquisition channel analysis and sales-cycle reporting.
--
-- Important:
--   This model currently represents only successfully
--   closed deals and does NOT include unsuccessful leads.
--
--   As a result, this model should NOT yet be interpreted
--   as a complete marketing funnel representation.
--
--   days_to_close measures the duration between
--   first contact and closed deal date.
--
-- Not Yet Included:
--   - Full funnel stage progression
--   - Lost or abandoned leads
--   - Marketing spend attribution
--   - Channel conversion efficiency
--
-- Downstream Consumers:
--   - Semantic Layer (marketing)
--   - Marketing dashboards
--   - Funnel velocity reporting


{{ config(
    materialized="table",
    tags=['intermediate', 'dimension'],
    schema = "analytics"
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