{{ config(
    materialized='table',
    tags=['mart','marketing']
) }}

with rfm as (
    select
        customer_id,
        recency_days,
        frequency,
        monetary
    from {{ ref('customer_rfm_scores') }}
),

segments as (
    select
        customer_id,
        recency_days,
        frequency,
        monetary,
        case
            when recency_days <= 30 and frequency >= 5 and monetary >= 500 then 'Champions'
            when recency_days <= 60 and frequency >= 3 and monetary >= 300 then 'Loyal'
            when recency_days > 90 and frequency = 1 then 'At Risk'
            else 'Regular'
        end as rfm_segment
    from rfm
)

select *
from segments