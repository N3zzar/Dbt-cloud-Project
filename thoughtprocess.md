# DBT Project Thought Process and Design Decisions

This README explains the thought process behind the dbt project I completed.

---

## Warehouse Choice and Evolution

In the project I completed, I initially used **Snowflake**. However, once I realized that after my trial ended I would no longer be able to access it, I had to switch to **PostgreSQL** and eventually to **Aiven** in that project.

Consequently, the 30-day trial on my Snowflake account elapsed, and in terms of novelty, Snowflake, PostgreSQL, and Aiven were no longer viable options. After researching alternatives, I discovered **BigQuery**, which is why I ultimately decided to use it.

---

## Analyses

While working in the `analyses` folder, I noticed that some orders appeared multiple times with different order statuses. This would be a problem when performing calculations unless I explicitly filtered for delivered orders (which I did in the marts layer anyways).

Because I may want to perform further analysis using other order statuses (such as processing or shipped), I decided to return the **last order status** each order had. A stakeholder may also be interested in this information, and since I did not want to materialize it, I wrote all the SQL commands in a `.sql` file within the `analyses` folder.

---

## Packages

I installed popular dbt packages that are commonly used by dbt practitioners, including:

* `dbt_utils`
* `codegen`
* `audit_helper`
* `dbt_expectations`

I did not eventually use most of the packages I installed.

---

## Macros

Most of the macros I wrote were created mid-project. While working on the staging models, I noticed repeating syntax and, understanding the **D.R.Y. principle**, I wrote macros to eliminate this repetition.

### `cast_to_timestamp`

This macro uses a dictionary format where the key represents one or more columns to be converted, and the value represents the renamed column after converting it to the default timestamp type.

### `current_date`

This macro was written after realizing that the dataset dates back to 2018, while the warehouse current date is 2025. If I wanted to calculate recency metrics, using the warehouse’s current date would be ineffective. To solve this, I provided a configurable date through a variable defined in the `dbt_project.yml` file.

### `generate_schema_name`

This macro was created to ensure proper naming of schemas in the warehouse. Running `dbt run` would materialize tables and views in the same schema, and even when a target schema was provided, dbt would append the target name to the schema. This macro ensured proper folders naming so layers could be clearly categorized in the warehouse.

### `unknown_to_others`

This macro was written to address categorization issues. While checking unique values in some columns within the orders dataset, I noticed values such as `other` and `unknown`, which to me meant the same thing. This macro converts all null values and `unknown` to `other`; otherwise, it applies trimming and lowercasing to the remaining values.

All macros used in this project are documented in a `macros.yml` file.

---

## Seeds

While checking the `state` columns, I realized that they only contained abbreviations. I looked up the full Brazilian state names and created a CSV file (`state_full.csv`) mapping each abbreviation to its full name in the `seeds` folder.

After seeding the data into the warehouse, I had difficulty joining it to my tables. The join kept returning null values in the `dim_geography` table when `stg_geolocation` was left joined to `state_full.csv`. I also tried a right join, but it did not work.

I eventually resolved this issue by explicitly specifying the column types for the seed columns in the `dbt_project.yml` file.

---

## Snapshots

I learned more about snapshots while taking the dbt Advanced Developer track and wanted to implement them in this project. However, the dataset did not contain an `updated_at` timestamp, so I could not use the timestamp strategy.

Instead, I used the **check strategy**, implementing the required syntax, including:

* Hard deletes
* A unique key
* A list of columns to check for changes

I could not test whether the snapshot would fully work because doing so would require updating the database, and I could not run DDL commands on BigQuery on free tier. However, since there were no errors, I assume the snapshot configuration is valid.

---

## Tests

With the understanding that dbt supports three types of tests, I wanted to experiment with **singular tests**—assertions written against specific business logic.

* **`test_no_before_order_estimated_date`**
This was written with the understanding that ideally you dont get a date when your order will likely be delivered when you havent made an order and it can only be after your order date.

* **`test_no_negative_delivery`**
This was written because it also doesnt make sense that the day an order was delivered was before the date the order was purchased

* **`test_no_negative_revenue`**
This was just to ensure that there was no computational errors when writing the amount people paid for an order.
---

## dbt_project.yml

In addition to the configurations mentioned earlier, the `dbt_project.yml` file includes default configurations generated during project creation in dbt Cloud.

Additional configurations include:

* Materializations for different layers. 
* Schema destinations for each layer using naming conventions that reflect their purpose

Some configurations were later overridden using model-level config blocks as part of experimentation.

---

## Sources

When defining my sources, the new thing I did was to add a `loader` field which I stated as "Kaggle" which is cool because it explains where your data was coming from, into the warehouse

I defined the source tables and provided descriptions as usual. I also experimented with **source freshness**, applying it specifically to the orders table using `order_purchase_timestamp`.

Because the data only goes back to 2018, freshness checks initially failed. I resolved this by adjusting the `warn_after` and `error_after` thresholds so the freshness tests would pass while remaining meaningful.

---

## Exposures

This was a concept I was not new to, I had tried it in a former project, so I implemented it here as well because it is important. The new thing I added was the url which ideally should take you to the downstream usage, dashboard in this case, but I hadn't built one, so I used the dataset link.

---

## Markdown Files

While working on this project, I maintained a scratchpad `.md` files documenting experiments, observations, and my thought process. Although later deleted, this approach proved useful during this project.

I also experimented further with doc blocks to better explain the unique fields from the `order_status` column, which is critical for stakeholder understanding. Different statuses represent different stages in the order lifecycle, and comprehensive documentation was written covering:

* The column itself
* All possible order statuses
* Business logic rules

I later referenced this documentation in `.yml` files so it appears in dbt Docs.

---

## Staging layer

In the staging layer, I performed all typical transformations expected at this layer, including:

* Using the `source()` function
* Employing the macros I had written
* Using `dbt_utils` package to exclude columns instead of bringing everything in
* Adding per-model `.yml` documentation and tests in the two folders.

I prefixed my documentation files names with `__` to keep them at the top of folders. 

The documentation was also made faster with AI, but not the tests I wrote, because I had to critically assess it to understand where my dataset was faulting.

I employed tags throughout the project knowing that it also makes it easy and cost effective, when you are trying to do an operation in groups.

Learning about severity from dbt platform, I decided to apply it on my `order_status` column such that if it detects a new order status different from the one I provided in the accepted values, it should output warn instead of the default error message. This will allow production not to break.

---

## Intermediate Layer

I applied the usual typical transformation expected of intermediate layers too, including not using the source function again and joining multiple tables

This stage was also quite interesting because prior, I had not worked with creating folders based on the type of table - DIM and FACTS, and I didnt understand what they meant by grain level. Thanks to the bootcamp, I was able to understand and apply it.

### Dimensions

My Dimension models represent key entities such as sellers, locations, and marketing attributes. 

Understanding the pecularities of dimension tables (like using qualitative attributes, having unique primary keys etc), I created my models based on that, from multiple tables and with the default materialization being View.

My Tags for my dimension models were `intermediate` and `dimension` while 
  
### Facts
My facts folders as well contained models which were created with the characterisitcs of a fact table (like having two or more foreign keys).

My tags for my facts models, it was `intermediate` and `facts`. 

I'd read that the typical materialization for your intermediate layer are views but I was not sure my marts models it should still be a view, but seeing that this could also still be used for analytics, as it had other several foreign columns, I overrode the default materialization and materialized it as table and also the schema destination. 

I added a unique key in the confog block of my fact_orders to specify that the order_id was the natural business key. My documentation was organized per subfolder using `.yml` file. I also created a date table to be used as my dim_date table which would be useful for time intelligence calculations.

---

## Marts Layer

The idea of the folder naming I used here follows the folder structure specified in the bootcamp:

* `core`
* `marketing`

The marts layer was where I had to decide if I was going to keep on using all the orders or not, but knowing that an order in the database had multiple order statuses, I decided to go with just filtering for delivered orders in all my calculations. 

My marts models was calculated based on core business domain and all metrics relevant was calcualated. I also defined my tags based on the grain and subfolders. Although a `dim_date` table was created, it was not heavily used in this layer. 

My documentation was organized per Subfolder using a `.yml` file.

Models were built around core business domains, metrics were calculated accordingly, and tags were defined based on grain and subfolders. Although a `dim_date` table was created, it was not heavily used in this layer.
