select sum(monetary) from {{ ref('customer_rfm_scores') }}


-- select sum(total_value) from {{ ref('mart_product_performance') }}
-- where product_category_name IS NULL


-- Address schema issues
-- Address rich metadata 
-- Check if mr david repeated logic in his marts
-- 15843553.24 for all orders, 15419773.75  for delivered orders