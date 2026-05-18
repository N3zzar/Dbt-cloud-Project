-- customer_rfm_scores.sql
-- Grain:
--   One row per customer.
--
-- Purpose:
--   Behavioral customer segmentation model based on
--   Recency, Frequency, and Monetary (RFM) analysis.
--
-- Important:
--   frequency represents the number of delivered orders
--   placed by a customer.
--
--   monetary represents cumulative revenue generated
--   from delivered orders.
--
--   recency_days measures the number of days since
--   a customer's last purchase relative to the
--   defined snapshot date.
--
--   RFM scores are relative rankings and should be interpreted
--   comparatively rather than as absolute business thresholds.
--
-- Not Yet Included:
--   - Dynamic scoring thresholds
--   - Predictive churn scoring
--   - Customer propensity modeling
--   - Multi-period behavioral tracking
--
-- Downstream Consumers:
--   - Semantic Layer (customer_rfm_scores)
--   - Customer segmentation dashboards
--   - Retention analysis





{{ config(
    materialized='table',
    tags=['mart','marketing']
) }}

with customer_orders as ( 

    select
        customer_id,

        min(order_purchase_timestamp) as first_order_date,
        max(order_purchase_timestamp) as last_order_date,

        count(distinct order_id) as frequency,

        sum(total_order_value) as monetary

    from {{ ref('fct_orders') }}

    where order_status = 'delivered'

    group by 1

),

rfm_base as (

    select
        customer_id,

        cast(current_timestamp as date) as snapshot_date,

        first_order_date,
        last_order_date,

        frequency,
        monetary,

        date_diff(
            date('2018-10-31'),
            date(last_order_date),
            day
        ) as recency_days,

        date_diff(
            date(last_order_date),
            date(first_order_date),
            day
        ) as customer_lifespan_days,

        safe_divide(monetary, frequency) as avg_order_value

    from customer_orders

),

rfm_scores as (

    select
        *,

        ntile(5) over (
            order by recency_days asc
        ) as recency_score,

        ntile(5) over (
            order by frequency desc
        ) as frequency_score,

        ntile(5) over (
            order by monetary desc
        ) as monetary_score

    from rfm_base

)

select
    customer_id,

    snapshot_date,

    recency_days,
    frequency,
    monetary,

    recency_score,
    frequency_score,
    monetary_score,

    concat(
        recency_score,
        frequency_score,
        monetary_score
    ) as rfm_score,

    case
        when recency_score >= 4
             and frequency_score >= 4
             and monetary_score >= 4
        then 'champions'

        when recency_score >= 4
             and frequency_score >= 3
        then 'loyal_customers'

        when recency_score <= 2
        then 'at_risk'

        else 'others'
    end as customer_segment,

    customer_lifespan_days,
    avg_order_value

from rfm_scores