Check for payment_type mappings, city mapping as seeds
Custom schema configuration
Configure Snapshots, then check after you have done dbt snapshots.
create date dim with jinja
seed documentation

Source freshness tests
tests, custom tests,
Custom target schemas with macros
mix seed (state_mapping) with stg_geography to get dim_geography
ad-hoc analyses queries



Delivery performance metrics

delivered_customer_ts - order_purchase_ts → actual delivery duration

Compare with estimated_delivery_ts → delay analysis

Revenue & contribution analysis

Aggregate price + freight_value by seller, region, product category

Marketing ROI / Funnel

Join marketing dimension → closed_deals → orders → revenue per lead origin/landing page

Regional insights

Join customer and seller geolocations → measure distance, regional sales efficiency

Segmentation

Customer segmentation by zip code / order frequency / total spent

Seller segmentation by number of orders, revenue, delivery efficiency



orders_mart → combine fact_orders + dim_customer + dim_seller

sales_mart → combine fact_order_items + dim_product + dim_seller + dim_customer

payments_mart → combine fact_payments + fact_order_items + dim_customer + dim_seller

marketing_mart → combine dim_marketing + fact_orders → conversion, revenue per campaign


I am thinking of adding a revenue marts

Sales / Orders Mart → Revenue, order trends, product/category performance

Payments Mart → Payment insights, installments, payment type trends




Notes
Some orders had zero order order_items
not all the orders_id were represented in the order_items tables, and the ones that were there still had duplicates
all orders_id were represented in the order_payment table but some had duplicates with different values
Is it advisable to write tests on the source or the staging layer?
I am unable to write a doc block


I want to add deployment
I want to add macro for my cleaning


Observations
Not all sellers in the stg_sellers closed the deals, so we can do referential integrity. Lets do for that of country tho.
Product, orders, sellers, product_category are uniques, no nulls.
Some products didnt belong to any category
All customers in the database ordered something
Some orders had multiple payment type. I guess this must have been due to the installments, failed transfer.
All orders were represented in the order_items table.
Some orders that had transactions were not unique. They had different order_status
I cant do incremental on my orders table because it is not a always changing data




Severity
Deploymemt
Last order_status recorded and timetamp