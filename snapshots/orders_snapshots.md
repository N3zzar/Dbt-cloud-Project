version: 2

snapshots:
  - name: order_snapshot
    description: "Snapshot of Olist orders using check strategy and tracking changes"
    config:
      database: n3zzar              # BigQuery project
      schema: snapshots             # dataset
      unique_key: order_id
      strategy: check
      check_cols:
        - customer_id
        - order_status
        - order_purchase_timestamp
      dbt_valid_to_current: "9999-12-31"
      meta:
        hard_deletes: ignore