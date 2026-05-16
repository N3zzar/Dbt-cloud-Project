semantic_models:

  #--------------------------------------
  # 1. Fct_orders - one row per order
  #--------------------------------------


  - name: orders
    description: Order-level transactional fact table.

    model: ref('fct_orders')

    defaults:
      agg_time_dimension: order_purchase_timestamp

    entities:
      - name: order
        type: primary
        expr: order_id

      - name: customer
        type: foreign
        expr: customer_id

    dimensions:

      # Time dimensions
      - name: order_purchase_timestamp
        type: time
        expr: order_purchase_timestamp

        type_params:
          time_granularity: day

      - name: order_delivered_customer_date
        type: time
        expr: order_delivered_customer_date

        type_params:
          time_granularity: day

      # Categorical dimensions
      - name: order_status
        type: categorical

      - name: order_size_bucket
        type: categorical

      # Boolean dimensions
      - name: is_delayed
        type: categorical

      - name: is_delivered_on_time
        type: categorical

    measures:

      - name: total_order_revenue
        description: Revenue per order including items + freight.
        agg: sum
        expr: total_order_value

      - name: total_orders
        description: Count of unique orders.
        agg: count_distinct
        expr: order_id

      - name: total_items
        description: Total items purchased.
        agg: sum
        expr: total_items

      - name: average_delivery_delay_days
        description: Average delivery delay in days.
        agg: average
        expr: delivery_delay_days

  #--------------------------------
  # 2. Fct_order_items - One row per order item
  #--------------------------------

  - name: order_items
    description: Item-level order transaction facts.

    model: ref('fct_order_items')

    defaults:
      agg_time_dimension: order_purchase_timestamp

    entities:
      - name: order_item
        type: primary
        expr: order_item_id

      - name: order
        type: foreign
        expr: order_id

      - name: product
        type: foreign
        expr: product_id

      - name: seller
        type: foreign
        expr: seller_id

    dimensions:

      - name: order_purchase_timestamp
        type: time
        expr: order_purchase_timestamp

        type_params:
          time_granularity: day

      - name: order_status
        description: for fulfillment analysis
        type: categorical

      - name: product_category_name_english
        description: for category slicing
        type: categorical

    measures:

      - name: item_revenue
        description: Revenue generated from product sales.
        agg: sum
        expr: price

      - name: freight_revenue
        description: Freight revenue from shipped items.
        agg: sum
        expr: freight_value

      - name: total_item_value
        description: Product price plus freight value.
        agg: sum
        expr: total_item_value

      - name: units_sold
        description: Total order items sold.
        agg: count
        expr: order_item_id

  #-------------------------------
  # Fct_marketing - One row per closed deals
  #------------------------------

  - name: marketing
    description: Marketing qualified leads and closed deal facts.

    model: ref('fct_marketing')

    defaults:
      agg_time_dimension: first_contact_date

    entities:
      - name: mql
        type: primary
        expr: mql_id

      - name: seller
        type: foreign
        expr: seller_id

    dimensions:

      # Time dimensions
      - name: first_contact_date
        type: time
        expr: first_contact_date

        type_params:
          time_granularity: day

      - name: won_date
        type: time
        expr: won_date

        type_params:
          time_granularity: day

      # Marketing attribution
      - name: origin
        description: Lead acquisition channel.
        type: categorical

      - name: business_segment
        type: categorical

      - name: lead_category
        type: categorical

    measures:

      - name: total_mqls
        description: Total marketing qualified leads.
        agg: count_distinct
        expr: mql_id

      - name: total_closed_deals
        description: Total successfully closed deals.
        agg: count_distinct
        expr: seller_id

      - name: average_days_to_close
        description: Average number of days required to close a deal.
        agg: average
        expr: days_to_close

      - name: closed_deals
        description: Successfully closed/won deals
        agg: count_distinct
        expr: mql_id