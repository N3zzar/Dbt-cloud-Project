select *
from {{ ref('fct_orders') }}
where order_delivered_customer_date < order_purchase_timestamp