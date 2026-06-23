# Olist Brazilian E-Commerce Analytics Platform v2

**End-to-End Analytics Engineering with dbt, Semantic Modeling, Governed Metrics, and Lightdash**

📚 **Version 1 Project:** [Link to V1 Repository](https://github.com/N3zzar/Dbt-cloud-Project-initialversion.git)

📖 **Interactive dbt Documentation:** [Link to dbt Docs](https://oj980.us1.dbt.com/api/ide/v3/70471823492852/legacy/files/docs/index.html#!/overview)

---

## Overview

This project is the second iteration of the Olist Brazilian E-Commerce Analytics Platform.

Version 1 focused on building a trusted dimensional warehouse using dbt and BigQuery. Version 2 extends that foundation by introducing semantic modeling, centralized metric governance, enhanced data quality controls, analytical validation, and business-facing dashboards built with Lightdash.

The goal of this release was to move beyond warehouse modeling and establish a complete analytics workflow—from raw data to governed metrics and stakeholder-ready insights.

For implementation details that remain unchanged — including staging architecture, snapshots, macros, CI/CD, source freshness checks, and foundational dimensional modeling—please refer to the Version 1 documentation.

---

## Business Context

Olist is a Brazilian marketplace that connects sellers to customers through a multi-sided commerce platform.

The datasets capture the complete customer journey, including:

* Marketing lead generation
* Seller acquisition
* Customer acquisition
* Orders
* Payments
* Logistics
* Delivery performance

The platform enables analysis across multiple business domains:

### Customer Analytics

* Customer Lifetime Value
* Customer Segmentation
* Retention Analysis
* Cohort Analysis

### Sales Performance

* Revenue Trends
* Average Order Value
* Product Performance
* Category Performance

### Marketing Analytics

* Lead Conversion
* Funnel Performance
* Seller Acquisition

### Operations & Logistics

* Delivery Performance
* Shipping Delays
* Fulfillment Efficiency

---

## What's New in Version 2

### Semantic Layer & Metric Governance

Version 2 introduces a dbt Semantic Layer and centralized metric definitions, creating a governed business layer between transformed warehouse models and downstream BI tools.

This layer standardizes:

* Entities
* Dimensions
* Measures
* Relationships
* Business KPIs

Key metrics include:

* Total Revenue
* Orders Count
* Customer Count
* Average Order Value (AOV)
* Customer Lifetime Value (CLV)
* Retention Rate
* Repeat Purchase Rate

By defining metrics once and exposing them through semantic models, all downstream dashboards consume the same business logic and calculations.

#### Benefits

* Consistent reporting across dashboards
* Reduced metric duplication
* Improved metric discoverability
* Self-service analytics enablement
* Version-controlled business logic

![semantic-models.png](https://github.com/N3zzar/Dbt-cloud-Project/blob/c069e069cd592b152165d0d33dd4bc357f482e5a/images%20/%20Semantic%20Layer%20Implementation.jpg)

![Metrics Configuration](metrics-config.png)

---

### Lightdash Dashboards

Version 2 introduces a business intelligence layer through Lightdash.

By consuming semantic models and governed metrics directly from dbt metadata, dashboards in lighttdash inherit standardized business definitions and documentation automatically.

Business domains covered include:

* Sales Performance
* Customer Analytics
* Customer Retention & Cohorts Analysis
* Marketing & Seller Acquisition
* RFM Segmentation
* Product Performance

---

### Analytical Validation

A major focus of Version 2 was improving analytical correctness.

Several calculations from Version 1 were revisited and validated against source data to ensure consistency across warehouse models, semantic definitions, metrics, and dashboards.

Validation activities included:

* Revenue verification
* Order count verification
* Customer count verification
* Marketing funnel validation
* Dashboard cross-checking

This process (which invovlved cross-checking important values in lightdash, dbt and bigquery) helped identify and correct calculation inconsistencies, resulting in more reliable business reporting.

![Validation Process](analytics-validation.png)

---

### Data Quality & Governance

Compared to Version 1, the testing framework was expanded significantly.

Enhancements include:

* Grain enforcement tests
* Unique combination tests
* Relationship tests
* Accepted value tests
* Referential integrity tests
* Semantic model validation
* Metric validation

All analytical models now have explicitly documented grains that are enforced through testing and semantic model definitions, helping prevent duplication and double counting.

| Model              | Grain                  |
| ------------------ | ---------------------- |
| `fct_orders`      | One row per order      |
| `fct_order_items` | One row per order item |
| `fct_marketing`   | One row per mql   |
| `mart_customer`      | One row per customer    |
| `mart_product_performance`       | One row per product|
| `mart_sales` | One row per delivered order|
| `customer_cohort` | One row per cohort_month x order_month combination|
| `customer_rfm_score` | One row per customer|

![dbt Tests](dbt-tests.png)

---

### Marketing Model Refinement

Following further analysis of the marketing funnel dataset, the marketing model structure was refined.

#### Version 1

```text
Dimensions
└── dim_marketing
```

#### Version 2

```text
Facts
└── fact_marketing
```

The model was reclassified to better reflect its analytical usage patterns, improving alignment with dimensional modeling best practices.

---

## Architecture

Version 2 expands the architecture to include semantic modeling and BI consumption layers.

```text
Raw Data
    ↓
Google BigQuery
    ↓
dbt Staging
    ↓
dbt Intermediate
    ↓
dbt Marts
    ↓
Semantic Models
    ↓
Metrics Layer
    ↓
Lightdash Dashboards
```

![Architecture Diagram](architecture-v2.png)

---

## Updated Project DAG

The dbt DAG has been expanded to include semantic models and metric definitions alongside the traditional transformation layers.

![Version 2 DAG](olist-v2-dag.png)

---

## Business Dashboards

### Revenue Performance Dashboard

Insights include:

* Revenue trends
* Average order value
* Revenue by states

![Revenue Dashboard](revenue-dashboard.png)

---

### Customer & Cohort Analytics Dashboard

Insights include:

* Customer revenue
* Customer lifetime value
* Customer by states

![Customer Dashboard](customer-dashboard.png)

---

### Marketing & Seller Acquisition Dashboard

Insights include:

* Closed deals trend
* Closed deals by business segment
* Total revenue by origin

![Marketing Dashboard](marketing-dashboard.png)

---

### RFM Segmentation Dashboard

Insights include:

* Customer segments
* Revenue contribution by segment
* RFM scores per customer

![RFM Dashboard](rfm-dashboard.png)

---

## Technology Stack

| Layer                 | Technology                                   |
| --------------------- | -------------------------------------------- |
| Data Source           | Olist E-Commerce & Marketing Funnel Datasets |
| Data Warehouse        | Google BigQuery                              |
| Transformation        | dbt Cloud                                    |
| Semantic Layer        | dbt Semantic Layer                           |
| Business Intelligence | Lightdash                                    |
| Version Control       | GitHub                                       |
| CI/CD                 | dbt Cloud Slim CI                            |

---

## Documentation

Interactive documentation includes:

* Sources
* Models
* Tests
* Macros
* Exposures
* Semantic Models
* Metrics
* Lineage

📖 **dbt Documentation:** [(https://oj980.us1.dbt.com/api/ide/v3/70471823492852/legacy/files/docs/index.html#!/overview]

---

## Comparison with Version 1

| Capability                | Version 1 | Version 2     |
| ------------------------- | --------- | ------------- |
| Dimensional Modeling      | ✅         | ✅             |
| Analytics Marts           | ✅         | ✅             |
| Snapshots                 | ✅         | ✅             |
| Source Freshness          | ✅         | ✅             |
| Semantic Layer            | ❌         | ✅             |
| Metrics Layer             | ❌         | ✅             |
| Lightdash Dashboards      | ❌         | ✅             |
| Metric Governance         | ❌         | ✅             |
| Enhanced Grain Validation | ❌         | ✅             |
| Analytical Validation     | Partial   | Comprehensive |
| Self-Service Analytics    | ❌         | ✅             |

---

## What This Project Demonstrates

* Analytics Engineering with dbt
* Dimensional Modeling
* Semantic Modeling
* Metric Governance
* Data Quality Enforcement
* Dashboard Development
* Business Intelligence Enablement
* Analytics Documentation
* End-to-End Data Ownership

---

## Future Enhancements

* Incremental Models
* MetricFlow Query Serving
* Cost Optimization Strategies
* Data Observability Tooling
* Reverse ETL Activation

---

## Additional Links

* Version 1 Repository
* Thought Process Documentation https://github.com/N3zzar/Dbt-cloud-Project-initialversion/blob/e414e541fcac662f36fe9f7b35bdd1445c9a6ba7/thoughtprocess.md

---

## Author

**Nezzar**

Analytics Engineer

---

*This project evolves the original Olist Analytics Engineering Platform by introducing semantic modeling, governed metrics, analytical validation, and self-service business intelligence capabilities.*
