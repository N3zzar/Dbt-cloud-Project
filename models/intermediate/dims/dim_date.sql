{{ config(materialized='view') }}

WITH boundary AS (
    SELECT
        MIN(order_purchase_timestamp) AS start_date,
        MAX(order_delivered_customer_date) AS end_date
    FROM {{ ref('fact_orders') }}
),

date_spine AS (
    SELECT
        day
    FROM boundary, 
    UNNEST(GENERATE_DATE_ARRAY(
        DATE(start_date),
        DATE(end_date),
        INTERVAL 1 DAY
    )) AS day
)

SELECT
    day AS date_day,
    EXTRACT(DAY FROM day) AS day,
    EXTRACT(DAYOFWEEK FROM day) AS day_of_week,
    FORMAT_DATE('%A', day) AS day_name,
    CASE WHEN EXTRACT(DAYOFWEEK FROM day) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,
    EXTRACT(WEEK FROM day) AS week_number,
    EXTRACT(MONTH FROM day) AS month,
    FORMAT_DATE('%B', day) AS month_name,
    EXTRACT(QUARTER FROM day) AS quarter,
    EXTRACT(YEAR FROM day) AS year,
    DATE_TRUNC(day, YEAR) AS year_start_date
FROM date_spine
ORDER BY day