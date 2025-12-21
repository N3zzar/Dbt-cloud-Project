# Olist Brazilian E-Commerce Analytics Platform

**End-to-end analytics engineering with dbt and BigQuery**

## Overview

This project is an end-to-end **analytics engineering implementation** built on the Olist Brazilian E-Commerce and Marketing Funnel datasets. It demonstrates how raw marketplace data can be transformed into **trusted, analytics-ready facts and dimensions** using modern analytics engineering best practices.

The project applies a **dbt-first approach** with layered modeling, testing, documentation, snapshots, and reusable macros to enable consistent, decision-ready analytics for business stakeholders.

---

## Business Context

Olist is a Brazilian marketplace that connects sellers to customers. The datasets capture the full lifecycle of an order from marketing leads, customer acquisition, ordering, payment, logistics, and fulfillment.

This analytics platform answers key business questions across:

* **Customer analytics**: lifetime value, retention, RFM, cohorts
* **Sales performance**: revenue trends, AOV, category performance
* **Payments behavior**: installments and payment methods
* **Operations & logistics**: delivery performance and delays
* **Marketing effectiveness**: lead conversion and seller acquisition

---

## Key Analytical Guarantees

This project enforces the following analytical assumptions:

* Revenue and customer metrics are calculated **only on delivered orders**
* Dimension and Fact tables are modeled at clearly defined grains (order-level, item-level, customer-level)
* Dimensions provide descriptive context and are reusable across marts
* Metrics are consistent across analyses due to centralized transformations and tests

---

## Architecture

**Raw Data → BigQuery → dbt (Staging → Intermediate → Marts) → Downstream usage**

* Raw datasets are loaded unchanged
* dbt enforces modeling standards, data quality, and documentation
* Analytics marts expose business-ready tables for downstream consumption

---

## Tech Stack

* **Data Source**: Kaggle (Olist Brazilian E-Commerce & Marketing Funnel datasets)
* **Data Warehouse**: Google BigQuery
* **Transformation**: dbt Cloud
* **Modeling Paradigm**: Dimensional modeling
* **Version Control**: GitHub

**Analytics Engineering Practices**

* Layered modeling
* Incremental models
* Data tests and severity handling
* Snapshots for slowly changing data
* Macros and Jinja for DRY transformations
* Source freshness checks
* Exposures for downstream use cases

---

## Data Modeling Approach

The project follows a layered dbt architecture designed for scalability and trust.

### 1. Raw Layer

* Immutable source data loaded into BigQuery
* No transformations applied
* Serves as the immutable source of truth

---

### 2. Staging Layer (`models/staging/`)

**Purpose**

* Standardize column names and data types
* Apply light, source-aligned cleaning (trimming, casing, casting)
* Preserve one-to-one mapping with raw tables

**Characteristics**

* Built using `source()` references
* Built using CTEs and select statments
* Fully documented and tested
* Categorized based on source
* Primary keys tested for:
  * `not_null`
  * `unique`
  * `relationships`
  * `accepted_values`

---

### 3. Intermediate Layer (`models/intermediate/`)

**Purpose**

* Join related entities (e.g. orders, customers, payments)
* Establish dimensional structure

**Design**

* Models separated into **dimensions** and **facts**
* Built exclusively using `ref()`
* Explicit grain definition per model (order-level, customer-level, etc.)
* Tagged and materialized appropriately (views vs tables)

---

### 4. Dimensions (`models/intermediate/dims/`)

Key dimensions include:

* `dim_customer`
* `dim_product`
* `dim_seller`
* `dim_geography` (derived from a seed + staging model)
* `dim_date` (package-generated)
* `dim_marketing`

**Properties**

* Descriptive, reusable attributes
* Fully documented and tested
* Serve as the backbone for analytical queries
* Materialized as views
* Tagged as intermediate, dimension.

---

### 5. Facts (`models/intermediate/facts/`)

Key fact tables:

* `fact_orders`
* `fact_order_items`

**Properties**

* Analytics-ready measures and calculated fields
* Materialized as tables in the `analytics` schema which is different from the default target schema
* Fully documented and tested
* Modeled at consistent, well-defined grains
* Tagged as intermediate, facts.
* Materialized as table

---

### 6. Business Marts (`models/marts/`)

**Purpose**

* Expose domain-specific, decision-ready datasets

**Structure**

#### Core Marts

* `customer_mart`
* `payment_mart`
* `sales_mart`

#### Marketing Marts

* `customer_rfm_scores`
* `customer_segments`
* `customer_cohorts`

**Design Principles**

* Organized by business domain
* Seperated into two folders
* Filtered to delivered orders only
* Materialized as tables
* Tested and documented per domain
* Tagged for discoverability, per subfolder

---

## Data Quality & Governance

* Source freshness checks defined on key tables
* Standard dbt tests applied across all layers
* Custom tests leveraged via packages
* Severity configured to distinguish warnings from failures
* Snapshots implemented using the **check strategy** to track changes in order attributes

---

## Jinja, Macros, Packages & Exposures

* Reusable macros enforce DRY principles across models
* Macros handle:
  * Safe timestamp casting
  * Null handling
  * Text normalization
  * Conditional cleaning logic
  * Target schema customization
* Popular dbt packages installed in `packages.yml`
* Exposures defined for downstream analytics use case as a Performance dashboard which depended on three models in the marts layer in my exposure.yml file.

---

## Seeds & Analyses

* Created, loaded, and referenced a seed file in the seeds folder to enrich geographic attributes
* Ad-hoc analyses queries included to output the last order status recorded per order.

---

## Documentation

* Source-level documentation via `sources.yml`
* Macro-level documentation via `macros.yml`
* Model-level documentation across all layers
* Doc blocks used for detailed business definitions (e.g., order statuses)

---

## How to Run

1. Load raw datasets into BigQuery
2. Configure dbt Cloud connection
3. Execute:

   ```bash
   dbt run
   dbt test
   ```

---

## What This Project Demonstrates

* Production-style analytics engineering with dbt
* Dimensional modeling and metric standardization
* Data quality enforcement and governance
* Business-aligned analytics marts
* End-to-end ownership from raw data to insights

---

## Future Improvements
- Incremental ingestion
- Metrics


---

## Additional Links
For detailed thoughts process while working on the project, check this:
- [Thought Process Documentation](thoughtprocess.md)


---

## Author

**Nezzar**  
Analytics Engineer

---

PS: *This project was developed as part of Young data professionals (YDP) dbt bootcamp project submission*
