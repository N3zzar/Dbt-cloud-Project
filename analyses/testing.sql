select sum(monetary) from {{ ref('customer_rfm_scores') }}


-- select sum(total_value) from {{ ref('mart_product_performance') }}
-- where product_category_name IS NULL


-- Address schema issues
-- Address rich metadata 
-- Check if mr david repeated logic in his marts
-- 15843553.24 for all orders, 15419773.75  for delivered orders


metrics:

  # =====================================================
  # REVENUE METRICS
  # =====================================================

  # -------------------------
  # Core Revenue Metrics
  # -------------------------

  - name: total_revenue
    label: Total Revenue
    description: Total revenue generated across all orders.

    type: simple

    type_params:
      measure: total_order_revenue


  - name: delivered_revenue
    label: Delivered Revenue
    description: Revenue generated from delivered orders only.

    type: simple

    type_params:
      measure:
        name: total_order_revenue

    filter: |
      {{ Dimension('customer_order__order_status') }} = 'delivered'


  - name: product_revenue
    label: Product Revenue
    description: Revenue generated from product sales excluding freight.

    type: simple

    type_params:
      measure:
        name: item_revenue


  - name: freight_revenue
    label: Freight Revenue
    description: Revenue generated from freight and shipping charges.

    type: simple

    type_params:
      measure:
        name: freight_revenue


  - name: total_product_value
    label: Total Product Value
    description: Combined product and freight value.

    type: simple

    type_params:
      measure:
        name: total_item_value


  - name: total_payments_received
    label: Total Payments Received
    description: Total payment value collected from customers.

    type: simple

    type_params:
      measure:
        name: total_payment_value


  # -------------------------
  # Revenue Efficiency Metrics
  # -------------------------

  - name: average_order_value
    label: Average Order Value
    description: Average revenue generated per order.

    type: derived

    type_params:
      expr: revenue / orders

      metrics:
        - name: delivered_revenue
          alias: revenue

        - name: total_orders
          alias: orders


  - name: revenue_per_item
    label: Revenue Per Item
    description: Average revenue generated per order item sold.

    type: derived

    type_params:
      expr: revenue / items

      metrics:
        - name: total_product_value
          alias: revenue

        - name: units_sold
          alias: items

    # =====================================================
    # FULFILLMENT METRICS
    # =====================================================

    # -------------------------
    # Delivery Time Metrics
    # -------------------------

  - name: avg_delivery_time
    label: Average Delivery Time
    description: Average number of days between purchase and customer delivery.

    type: simple

    type_params:
      measure:
        name: avg_delivery_days


  - name: avg_estimated_delivery_time
    label: Average Estimated Delivery Time
    description: Average estimated delivery duration in days.

    type: simple

    type_params:
      measure:
        name: avg_estimated_delivery_days


  - name: avg_delivery_delay_days
    label: Average Delivery Delay Days
    description: Average number of days orders were delivered late.

    type: simple

    type_params:
      measure:
        name: avg_delivery_delay_days


  # -------------------------
  # Fulfillment Volume Metrics
  # -------------------------

  - name: total_orders
    label: total orders
    description: number of orders
    type: simple

    type_params:
      measure:
        name: order_count
  
  - name: delayed_orders
    label: Delayed Orders
    description: Total number of delayed orders.

    type: simple

    type_params:
      measure:
        name: delayed_orders


  - name: on_time_orders
    label: On-Time Orders
    description: Total number of orders delivered on time.

    type: simple

    type_params:
      measure:
        name: on_time_orders


  # -------------------------
  # Fulfillment Ratio Metrics
  # -------------------------

  - name: delivery_delay_rate
    label: Delivery Delay Rate
    description: Percentage of orders delivered after the estimated delivery date.

    type: ratio

    type_params:
      numerator: delayed_orders
      denominator: total_orders


  - name: on_time_delivery_rate
    label: On-Time Delivery Rate
    description: Percentage of orders delivered on or before the estimated delivery date.

    type: ratio

    type_params:
      numerator: on_time_orders
      denominator: total_orders

  # =====================================================
  # CUSTOMER METRICS
  # =====================================================

  # -------------------------
  # Customer Volume Metrics
  # -------------------------

  - name: total_customers
    label: Total Customers
    description: Total distinct customers.

    type: simple

    type_params:
      measure:
        name: customer_count


  - name: repeat_customers
    label: Repeat Customers
    description: Customers who have placed more than one order.

    type: simple

    type_params:
      measure:
        name: repeat_customers


  # -------------------------
  # Customer Revenue Metrics
  # -------------------------

  - name: customer_lifetime_value
    label: Customer Lifetime Value
    description: Total revenue generated across customers.

    type: simple

    type_params:
      measure:
        name: customer_total_revenue


  - name: customer_average_order_value
    label: Customer Average Order Value
    description: Average order value across customers.

    type: simple

    type_params:
      measure:
        name: customer_avg_order_value


  # -------------------------
  # Customer Behavioral Metrics
  # -------------------------

  - name: customer_frequency
    label: Customer Frequency
    description: Average number of orders placed by customers.

    type: simple

    type_params:
      measure:
        name: frequency


  - name: customer_monetary_value
    label: Customer Monetary Value
    description: Average monetary value generated by customers.

    type: simple

    type_params:
      measure:
        name: monetary


  - name: avg_customer_lifetime_days
    label: Average Customer Lifetime Days
    description: Average duration between first and last customer purchase.

    type: simple

    type_params:
      measure:
        name: avg_customer_lifespan


  # -------------------------
  # Customer Ratio Metrics
  # -------------------------

  - name: repeat_customer_rate
    label: Repeat Customer Rate
    description: Percentage of customers who made repeat purchases.

    type: ratio

    type_params:
      numerator: repeat_customers
      denominator: total_customers

  # =====================================================
  # RETENTION METRICS
  # =====================================================

  # -------------------------
  # Cohort Volume Metrics
  # -------------------------

  - name: cohort_active_customers
    label: Cohort Active Customers
    description: Number of active customers within a cohort period.

    type: simple

    type_params:
      measure:
        name: cohort_customers


  # -------------------------
  # Cohort Revenue Metrics
  # -------------------------

  - name: cohort_revenue
    label: Cohort Revenue
    description: Revenue generated by customers within a cohort period.

    type: simple

    type_params:
      measure:
        name: cohort_revenue


  # -------------------------
  # Retention Ratio Metrics
  # -------------------------

  - name: retention_rate
    label: Retention Rate
    description: Percentage of customers retained across cohort periods.

    type: derived

    type_params:

      expr: active_customers / cohort_size

      metrics:

        - name: cohort_active_customers
          alias: active_customers

        - name: total_customers
          alias: cohort_size

  # =====================================================
  # PRODUCT METRICS
  # ====================================================


  # -------------------------
  # Product Sales Metrics
  # -------------------------

  - name: units_sold
    label: Units Sold
    description: Total quantity of order items sold.

    type: simple

    type_params:
      measure:
        name: units_sold


  - name: total_order_items
    label: Total Order Items
    description: Count of distinct order items.

    type: simple

    type_params:
      measure:
        name: order_item_count


  # -------------------------
  # Product Efficiency Metrics
  # -------------------------

  - name: avg_product_price
    label: Average Product Price
    description: Average revenue generated per item sold.

    type: derived

    type_params:

      expr: revenue / items

      metrics:

        - name: product_revenue
          alias: revenue

        - name: units_sold
          alias: items


  - name: avg_freight_per_item
    label: Average Freight Per Item
    description: Average freight value charged per item sold.

    type: derived

    type_params:

      expr: freight / items

      metrics:

        - name: freight_revenue
          alias: freight

        - name: units_sold
          alias: items


  # =====================================================
  # MARKETING FUNNEL METRICS
  # =====================================================

  # -------------------------
  # Funnel Volume Metrics
  # -------------------------

  - name: total_closed_deals
    label: Total Closed Deals
    description: Total successfully closed marketing deals.

    type: simple

    type_params:
      measure:
        name: closed_deals


  - name: total_sellers
    label: Total Sellers
    description: Total sellers associated with closed deals.

    type: simple

    type_params:
      measure:
        name: seller_count


  # -------------------------
  # Funnel Velocity Metrics
  # -------------------------

  - name: avg_sales_cycle_length
    label: Average Sales Cycle Length
    description: Average number of days required to close a deal.

    type: simple

    type_params:
      measure:
        name: avg_days_to_close


  # -------------------------
  # Funnel Efficiency Metrics
  # -------------------------

  - name: deals_per_seller
    label: Deals Per Seller
    description: Average number of closed deals per seller.

    type: derived

    type_params:

      expr: deals / sellers

      metrics:

        - name: total_closed_deals
          alias: deals

        - name: total_sellers
          alias: sellers