select *
from {{ ref('fact_orders') }}
where order_estimated_delivery_date < order_purchase_timestamp
