{% snapshot order_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='order_id',
    strategy='check',
    check_cols=['customer_id', 'order_status', 'order_purchase_timestamp']
  )
}}

select * from {{ ref('stg__orders') }}

{% endsnapshot %}