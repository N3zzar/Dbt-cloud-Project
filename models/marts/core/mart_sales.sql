-- mart_sales.sql
-- Grain:
--   One row per delivered order.
--
-- Purpose:
--   Sales reporting mart optimized for time-based
--   business intelligence and dashboard reporting.
--
-- Important:
--   Only delivered orders are included in this model.
--
--   Date dimensions are joined from dim_date to support
--   flexible calendar reporting in BI tools.
--
--   Revenue and fulfillment metrics in this model inherit
--   definitions from fct_orders.
--
-- Not Yet Included:
--   - Fiscal calendar support
--   - Regional sales segmentation
--   - Promotion and discount analysis
--   - Refund-adjusted revenue
--
-- Downstream Consumers:
--   - Lightdash dashboards
--   - Executive reporting
--   - Revenue trend analysis


{{ config(
    materialized='table',
    tags=['mart', 'core', 'sales']
) }}

with base_orders as (

    select
        o.order_id,
        o.customer_id,

        o.order_purchase_timestamp,
        date(o.order_purchase_timestamp) as purchase_date,

        o.order_status,

        o.total_items,
        o.total_order_value,

        o.delivery_days,

        o.estimated_delivery_days,

        o.is_delivered_on_time,

        o.is_delayed

    from {{ ref('fct_orders') }} o

    where o.order_status = 'delivered'

),

final as (

    select
        bo.*,

        dc.customer_city,
        dc.customer_state,
        dc.customer_state_abbrev,

        dd.day,
        dd.day_of_week,
        dd.day_name,
        dd.is_weekend,
        dd.week_number,
        dd.month,
        dd.month_name,
        dd.quarter,
        dd.year

    from base_orders bo
    left join {{ ref('dim_date') }} dd
        on bo.purchase_date = dd.date_day
    left join {{ ref('dim_customer') }} dc
        on bo.customer_id = dc.customer_id

)

select *
from final