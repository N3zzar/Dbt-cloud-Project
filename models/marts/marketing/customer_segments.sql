{{ config(
    tags=['mart','marketing']
) }}

with rfm as (
    select
        customer_id,
        recency_months,
        frequency,
        monetary
    from {{ ref('customer_rfm_scores') }}
),

segments as (
    select
        customer_id,
        recency_months,
        frequency,
        monetary,
case
            when
                recency_months <= 25 and frequency = 1 and monetary >= 700000
                then 'Champions'
            when
                recency_months <= 45 and frequency = 1 and monetary >= 400000
                then 'Loyal'
            when recency_months > 35 and frequency = 1 and monetary >= 100000 then 'Regular'
            else 'At risk'
        end as rfm_segment
    from rfm
)

select *
from segments
