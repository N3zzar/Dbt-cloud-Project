select *
from {{ ref('fct_orders') }}
where order_estimated_delivery_date < order_purchase_timestamp