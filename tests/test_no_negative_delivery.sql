select *
from {{ ref('fact_orders') }}
where order_delivered_customer_date < order_purchase_timestamp