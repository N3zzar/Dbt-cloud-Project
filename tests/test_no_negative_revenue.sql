select *
from {{ ref('fact_orders') }}
where payment_value < 0