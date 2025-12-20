# Young Data Professional dbt Bootcamp: Olist Brazilian E-Commerce Analytics (Nezzar's Assignment Submission)

## Overview

This project is an end-to-end **analytics engineering implementation** built on the Olist Brazilian E-Commerce datasets. It demonstrates how raw marketplace data can be transformed into **trusted, analytics-ready facts and dimensions** using modern data engineering and analytics engineering best practices.

The project follows a **dbt-first approach** with clear data modeling layers, strong documentation, testing, and reusable macros, enabling reliable downstream analytics for business stakeholders.

It is the implementation of what I had learnt before, what I had practiced before and what the bootcamp taught me.

---

## Business Context

Olist is a Brazilian marketplace that connects sellers to customers. The datasets capture the full lifecycle of an order from marketing leads, customer acquisition, ordering, payment, logistics, and fulfillment.

This project answers key business questions across:

- Customer analytics (LTV, retention, RFM, cohorts)
- Sales performance (revenue trends, AOV, category performance)
- Payments behavior (installments, payment methods)
- Operations & logistics (delivery performance, delays)
- Marketing effectiveness (lead conversion and seller acquisition)

---

## Tech Stack

- **Data Source**: Kaggle (Olist Brazilian E-Commerce & Marketing Funnel datasets)
- **Data Warehouse**: Google BigQuery
- **Transformation Tool**: dbt Cloud
- **Modeling Paradigm**: Dimensional modeling (Staging → Intermediate → Marts)
- **Analytics Engineering Practices**:
  - Incremental models
  - Data tests
  - Documentation
  - Macros (DRY transformations)
  - Semantic layer readiness
  - Snapshots

---

Sources
I defined my souces in the sources.yml file which linked to my raw database.
I performed a source freshness checks on the olist_orders_dataset using the order_purchase_timetamp column.
Added decsriptions as well to each tables.

## Data Architecture

### 1. Raw
- Kaggle datasets loaded directly into BigQuery
- No transformation
- Serves as immutable source of truth

### 2. Staging Layer/Landing Zone (`models/staging/`)

**What I did:**
- Standardize column names and data types
- Selecting the proper columns
- Renaming of some values (unknown to other)
- Apply lightweight cleaning (trimming, casing, casting)
- One-to-one mapping with source tables using the {{ source('schema', 'table') }} function.
- Built the complete staging layer for all my tables.
- Built using CTEs and Select statements.

**Key staging models:**
- `stg_orders`
- `stg_order_items`
- `stg_order_payments`
- `stg_customer`
- `stg_products`
- `stg_product_category`
- `stg_sellers`
- `stg_geolocation`
- `stg_marketing_qualified_leads`
- `stg_closed_deals`  

Each staging model is:
- Fully documented via their respective `.yml` files.
- The primary key was tested for `not_null`, `unique`, `accepted_values`, and `relationships`
- Was categorized in folders based on source: 1. Marketing_funnel folder contained datasets gotten on the Olist database. 2) olist folder contained datasets gotten in the marketing funnel provided by olist.

---

### 3. Intermediate Layer/Cleaned (`models/intermediate/`)

**Key concepts implemented:**
- Seperation into dims and facts folder
- Materialised the models under it as tables and views accordingly.
- Added tags
- Joining related entities (e.g. orders, customers, payments)
- Resolving grain (order-level, customer-level, etc.)
- Built using only the ref function {{ ref('model_name') }}
- Followed proper naming conventions and folder structure

---

#### 4. Dimensions (`models/intermediate/dims/`)

Dimensions created:
- `dim_customer` - This contained qualitative attributes on the customer grain level
- `dim_product` - This contained qualitative attributes on the product grain level
- `dim_seller` - This contained qualitative attributes on the seller grain level
- `dim_geography` - This contained qualitative attributes on the zip code grain level
- `dim_date` - This created from a package, contained qualitative attributes on the date grain level
- `dim_marketing` - This contained qualitative attributes on the marketing grain level

These dimensions:
- Contain descriptive attributes
- Are documented and tested via the `__dimensional_models.yml`
- Serve as the backbone of analytical queries
- Were materialized as views
- Tagged as intermediate, dimension.

---

### 5. Facts (`models/intermediate/facts/`)

Core fact tables:
- `fact_orders` - 
- `fact_order_items` - 

What I did
I practiced overiding the default target schema.
Materialized models as tables because they contained columns that could be used.
Added calculated fields


---

### 6. Business Marts/Analytics (`models/Marts/`)

Organized by business domain.
Seperated into two folders: Core folder contained customer_marts, payment_marts, sales_mart and the marketing folder contained customer_cohorts, customer_rfm_scores, customer_segments.
Filtering only for delivered order statuses.
- Built using only the ref function {{ ref('model_name') }}
- Followed proper naming conventions and folder structure
- 

#### (`models/Marts/core/`)
- customer_mart
- payment_mart
- sales_mart

#### (`models/Marts/marketing/`)
- `customer_rfm_scores`
- `customer_segments`
- `customer_cohorts`

---

## Jinja, Macros, Exposures, and Packages

Using jinja, I wrote some macros to ensure **DRY principles**:
- Safe casting (timestamp)
- Null handling
- Trimming and normalization
- Conditional cleaning logic
- Whitespace-controlled macro outputs
- Custom target schemas
I also installed some various packages - The popular ones.

In the exposure.yml file, I defined the downstream usecase as a Performance dashboard which depended on three models in the marts layer. I also added other fields.

These macros are used across staging and intermediate layers to maintain consistency.
---
Analyses and seeds
I created a csv file in the seeds folder which had the full name of each states in brazil and it was loaded using dbt seeds.
It was later referenced.
I didnt get to do any adhoc analyses but I have an idea of how it works.

Snapshots
I used the check snapshots strategy because I saw that my orders table doesnt have the updated at column.
I defined the columns that It should check for changing values which will automatically trigger the snapshots.


---

## Testing Strategy

- Wrote tests in .yml files
- Performed standard dbt tests (not null, unique, relationship integrity, accepted values)
- Leveraged on custom tests from packages.
- Performed not null, unique tests on primary key column
- Performed not null on necessary columns.


---
Documentation
Performed documentation at the source level via the source.yml file
Performed documentation at the macro level via the macros.yml file
In my documentation, I added decsriptions and metadata.
Used doc blocks for a more expansive documentation explaining the various order status we have.


---

## Key Learnings & Best Practices Demonstrated

- Avoiding cartesian explosions by aggregating before joins
- Handling multiple payment methods per order
- Normalizing evolving order statuses
- Designing fact tables for incremental loads
- Structuring marts by business domain
- Building analytics-ready datasets, not just transformed tables

---

## How to Run

1. Load raw datasets into BigQuery
2. Configure dbt Cloud connection
3. Run:
   ```bash
   dbt run
   dbt test




















In the project I completed, I'd used snowflake but realizing that once my trial ended, I wont be able to access it and so I had to switch to postgresql and eventually to AIVEN in that project. Consequently the 30 days trial on my snowflake account has elapsed and in terms of novelty, snowflake, postgresql and aiven wasnt an option. Researching made me found out about Big query which was why I had to go with it.

Analyses folders 
I noticed some orders appeared multiple times with different order statuses. This was going to be a problem if I want to do some calculations unless I explicitly stated that I want only for delivered orders (which I did in my marts layer). Because I may want to do further analysis with other order statuses (like processing, shipped etc), I decided to return the order status each orders had last. A stakeholder may also be interested in this and since I didnt want to materialize it, I wrote all my SQL commands in a .sql file in my analyses folders.

Packages
I installed the popular libraries that dbt users uses including dbt_utils, code_gen, audit_helper and dbt_expectations.
I didnt eventually use most of the packages I installed.

Macros
Most of the macros I wrote was later done mid project. Understanding the D.R.Y Principle, I saw that I had repeating syntax in my staging models, and such I had to write a macro to eliminate that.
Cast_to_timestamp macro used more of a dictionary format where the key was one or more columns that I wanted to convert and convert them to the default timestamp while renaming it as the value that I had stated.
The current_date macro was as a result of thinking that since my dataset was as far back as 2018 and we are in 2025, if I wanted to calculate recency, I would need to provide a current date and since it would be ineffective to use 2025 because that is the current date recognized as the warehouse and so I had to provide my own date through a variable I configured it in my dbt_project.yml file.
Generate_schema_name was just something I realized I needed to do because doing dbt run would materialize my tables and views in the same folder in my warehouse and even when I provided a target schema, it will append the target schema name to my folder name, so this macro was a way to ensure the proper naming of my folders to categorize my layers back in the warehouse.
Unknown_to_others macro was more of a solution to the categorization problem. Checking out the unique values of some columns in my orders dataset, there was `other` and there was `unknown` which to me meant the same thing so the macro was written to just convert all null values and `unknown` to other otherwise apply trimming and lowercare to other values.
I wrote a documentation for the macros I used in the macros.yml file.

Seeds
Checking the state columns, I realized there were just abbreviations so I looked up the full states in brazil and typed them in form of a csv to each abbreviation respectively, which was the content of my state_full.csv file in my seeds folder.
After seeding it into my warehouse, I should admit that I had a tough time joining it to the tables so I can add it. It kept returning null values on rows in the `dim_geography` table when the stg_geolocation was left joined on the state_full.csv. I tried right join, still didnt work. I later got around it through specifying the column types of the seeds columns in my dbt_project.yml.

Snapshots
I learnt more about snapshots during my time on the dbt advanced developer track and wanted to implemented in this project. However the issue was that my data didnt have the updated_at timestamp so I couldnt use the timestamp strategy so I decided to go with the check strategy. 
I implemented all the syntax I saw including hard_deletes, providing a unique key and list of columns to check and update if anything changes in those columns. 
I couldnt get to test if it will work because I think I have to update my database so it can then add the other timestamp columns there, but I coulndt run DDL commands on my big query without not paying.
But since there is no error, I assume it will work.

Tests
With the understanding that there are three types of tests in dbt, I wanted to experiment with the singular type which was assertions made on a particular columns
`test_no_before_order_estimated_date` was written from the understanding that ideally you dont get a date when your order will likely be delivered when you havent made an order and it can only be after your order date. And so applying this business logic and testing it, it passed the tests.
`test_no_negative_delivery` was written because it also doesnt make sense that the day an order was delivered was before the date the order was purchased and so I had to check this in my dataset to ensure it make sense according to the rules.
`test_no_negative_revenue` was just to ensure that there was no computational errors when writing the amount people paid for an order.

dbt_project
Asides what I mentioned that I did in my dbt_project.yml, there were default syntaxes that was also populated based on when I was creating a project in dbt cloud. The other thing I configured was the materialization of my different layers, of course some of them was later overridden by config blocks macros but that was just an experiment. I also specified  the schema my models under each layers will go to naming them with the typical names that denotes what they were housing.

Sources
When I was defining my sources, the new thing I did was to add a loader field which I stated as "Kaggle" which is cool because it explains from where your data was coming from, into the warehouse.
Did the usual thing I was familiar with, defining my tables and providing a description for them. However something new I wanted to try was source freshness. I didnt want to do it on the source itself because it was returning failed so I did it on the orders dataset in the source using the `order_purchase_timestamp`. It would also return failed because the data was far back as 2018 which means it wasnt fresh at all and so I had to ensure it pass the source freshness tests by tweaking the warn_after and error_after block.

Exposure
This was a concept I was not new to, I had tried it in former project so I implemented it here as well because it is important. The new thing I added was the url which ideally should take you to the downstream usage, dashboard in this case but I hadnt built one so I used the dataset link.

.md files
While working in this project, I had a scratch pad I was documenting the experiments I wanted to do, my observations, my thought process and all which was why this section here is robust. I deleted it already but I think it is a great resource for a scratch pad. Dont forget to delete afterwards tho.
I wanted to experiment again with doc blocks and realizing I havent done enough justice to the explanation of the unique fields in my order status columns which was important for stakeholders to understand the different stages your order can pass through (that a processing status is different from a invoiced status), and for a better analysis like funnel analysis, I had to write a more comprehensive one documenting both the column, the order statuses and the busines logic rules.
I later reference this in my .yml file so it will appear when viewing my documentation.

Staging model
I performed all the typical transformation expected at the staging model, including using the source function to connect with my source. I also employed the macros I had written, and used a package `dbt-utils` to exclude some columns instead of just bringing all.
I also added a .yml file per each model in the two folders where I documented each staging model, the columns they had and then performed the usual tests. In order for it to stay at the top, I added "__" to the naming.
The documentation was also made faster with AI, but not the tests I wrote because I had to critically assess it to understand where my dataset was faulting.
I employed tags in this layer and even throughout the model knowing that it also makes it easy when you are trying to do an operation in groups.
Learning about severity from dbt platform, I decided to apply it to while writing a test for my order_status column such that if it detect a new order status different from the one I provided in the accepted values, it should output warn instead of the default error message.

Intermediate
I performed all the typical transformation expected at the intermdiate model, including using several table joins
This was also quite interesting because prior, I had not worked with creating folders based on the type of table - DIM and FACTS and I didnt understand what they meant by grain level. Thanks to the bootcamp, I was able to understand and apply it. 
My Dimension folders had models that represented key entities (sellers, location, marketing etc). With the prior understanding of the pecularities of dimension tables (like using qualitative attributes, having unique primary keys etc), I created my models based on that, from two or more tables and allowed it the default materialization which is View.
My facts folders as well contained models which were created with the characterisitcs of a fact table (like having two or more foreign keys)
My tags for my dimension models were `intermediate` and `dimension` while for my facts models, it was `intermediate` and `facts`.
I applied the usual typical transformation expected of intermediate layers too, including not using the source function again.
I'd read that the typical materialization for your intermediate layer was 'view' and while I had created my facts table under it, I was not sure if it should still be a view. But seeing that this could also still be used for analytics, as it had other several foreign columns, I overrode the default materialization and materialized it as table and also the schema destination.
I added a unique key in the confog block of my fact_orders to specify that the order_id was the natural business key.
My documentation was based on Subfolder so it was per subfolder .yml file.
I also created a date table to be used as my `dim_date` table which would be useful for time intelligence calculations. 


Marts Layer
The idea of the folder naming I used here was based on what the bootcamp specificed on the readme file which was `core` and `marketing` 
The marts layer was where I had to decide if I was going to keep on using all the orders or not, but knowing that order 1 in the database had repetitions based on the order status, I decided to go with just filtering for delivered orders in all my calculations.
My marts models was calculated based on core business domain and all metrics relevant was calcualated
I also defined my tags based on the grain and subfolders.
I didnt really get to use the dim_date table I created as much as I wanted in the marts layer, because to some extent I had been able to exercise my knowledge on metrics and there was no need to do more.
My documentation was based on Subfolder so it was per subfolder .yml file.






