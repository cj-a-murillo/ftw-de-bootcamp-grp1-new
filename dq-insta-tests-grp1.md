# 🚀 FTW Data Engineering Bootcamp – Instacart Staging Models (dbt)

This module defines the clean staging layer for the Instacart dataset using **dbt**. It includes:

- Structured staging models (`g1_stg_insta_*`)
- Column-level dbt tests (structural + referential)
- Optional dashboard scaffolding for data quality (Metabase-ready)
- Auto-generated dbt docs 
---

## 1) 📂 Folder Structure

```
FTW-DE-BOOTCAMP-GRP1-NEW/
└── dbt/
    ├── Dockerfile
    ├── dbt_project.yml
    ├── profiles.yml
    ├── dbt_packages/
    ├── macros/
    │   ├── create_schema.sql
    │   ├── generate_database_name.sql
    │   ├── generate_schema_name.sql
    │   └── test_not_negative_id.sql      # test for checking negative int
    ├── models/
    │   ├── sources.yml
    │   ├── clean/
    │   │   ├── g1_stg_insta_aisles.sql
    │   │   ├── g1_stg_insta_departments.sql
    │   │   ├── g1_stg_insta_orders.sql
    │   │   ├── g1_stg_insta_products.sql
    │   │   ├── g1_stg_insta_users.sql
    │   │   └── schema.yml
    │   └── mart/
    |       ├── g1_insta_DimAisles.sql
    │       ├── g1_insta_DimDepartments.sql
    │       ├── g1_insta_DimDow.sql
    │       ├── g1_insta_DimProducts.sql
    │       ├── g1_insta_DimUsers.sql
    │       ├── g1_insta_FactOrder.sql
    │       ├── g1_insta_FactOrderProduct.sql
    │       ├── schema.yml
    |       └── dq/
    │            ├── g1_dq_insta_aisles_anomalies.sql
    │            ├── g1_dq_insta_aisles_summary.sql
    │            ├── g1_dq_insta_departments_anomalies.sql
    │            ├── g1_dq_insta_departments_summary.sql
    │            ├── g1_dq_insta_order_products_anomalies.sql
    │            ├── g1_dq_insta_order_products_summary.sql
    │            ├── g1_dq_insta_orders_anomalies.sql
    │            ├── g1_dq_insta_orders_summary.sql
    │            ├── g1_dq_insta_products_anomalies.sql
    │            ├── g1_dq_insta_products_summary.sql
    │            ├── g1_dq_insta_users_anomalies.sql
    │            ├── g1_dq_insta_users_summary.sql
    │            └── schema.yml
    ├── target/       # dbt docs output (after generation)
    │.....
```

---
## 2) 🧪 dbt Tests

---
## Adding custom test macro for dbt test schema.yml: 

#### 🧪 Custom dbt Test – `test_not_negative`

This macro defines a reusable test to validate that a given column in a model does **not contain negative values**. 
It’s useful for enforcing domain constraints on identifiers, metrics, or any field expected to be zero or positive.
##### 📄 Macro Definition

**Path:** `dbt/transforms/01_instacart/macros/test_not_negative_id.sql`

```sql
{% test not_negative(model, column_name) %}
SELECT *
FROM {{ model }}
WHERE {{ column_name }} < 0
{% endtest %}
```
---

## 🧱 Model Test Matrix

## A) Clean (structural tests)

This section documents the column-level tests applied to the Instacart staging models (`g1_stg_insta_*`). 
These tests ensure structural integrity, enforce domain constraints, and validate foreign key relationships.

* Validate not-null constraints, accepted values, and referential integrity tests.
* Defined in: `models/clean/schema.yml`

##### `g1_stg_insta_aisles`

| Column     | Tests                                  |
|------------|----------------------------------------|
| `aisle_id` | `not_null`, `unique`, `not_negative`   |
| `aisle`    | `not_null`                             |

---

##### `g1_stg_insta_departments`

| Column         | Tests                                 |
|----------------|----------------------------------------|
| `department_id`| `not_null`, `unique`, `not_negative`   |
| `department`   | `not_null`                             |

---

##### `g1_stg_insta_products`

| Column         | Tests                                                                  |
|----------------|------------------------------------------------------------------------|
| `product_id`   | `not_null`, `unique`, `not_negative`                                   |
| `product_name` | `not_null`                                                             |
| `aisle_id`     | `not_null`, `relationships → g1_stg_insta_aisles.aisle_id`             |
| `department_id`| `not_null`, `relationships → g1_stg_insta_departments.department_id`   |

---

##### `g1_stg_insta_order_products`

| Column             | Tests                                                                          |
|--------------------|--------------------------------------------------------------------------------|
| `order_id`         | `not_null`, `not_negative`, `relationships → g1_stg_insta_orders.order_id`     |
| `product_id`       | `not_null`, `not_negative`, `relationships → g1_stg_insta_products.product_id` |
| `add_to_cart_order`| `not_null`, `not_negative`                                                     |
| `reordered`        | `not_null`, `accepted_values: [0, 1]`                                          |

---

##### `g1_stg_insta_users`

| Column    | Tests                                  |
|-----------|----------------------------------------|
| `user_id` | `not_null`, `unique`, `not_negative`   |

---

##### `g1_stg_insta_orders`

| Column                | Tests                                                                  |
|-----------------------|------------------------------------------------------------------------|
| `order_id`            | `not_null`, `unique`, `not_negative`                                   |
| `user_id`             | `not_null`, `relationships → g1_stg_insta_users.user_id`               |
| `eval_set`            | `accepted_values: ['prior', 'train', 'test']`                          |
| `order_number`        | `not_null`                                                             |
| `order_dow`           | `accepted_values: [0–6]`                                               |
| `order_hour_of_day`   | `accepted_values: [0–23]`                                              |
| `days_since_prior_order` | nullable (first orders may be null)                                 |

---

## B) Mart (semantic tests)

* Validate not-null constraints, accepted values, and referential integrity tests.

```sql
ftw-de-bootcamp/dbt/transforms/01_instacart/models/mart/
```
#### 🧱 g1_insta_DimAisles

Dim table for Instacart aisles data.

| Column     | Description                      | Tests                                |
|------------|----------------------------------|--------------------------------------|
| aisle_id   | Unique identifier for each aisle | not_null, unique, not_negative       |
| aisle      | Aisle name                       | not_null                             |

---

#### 🧱 g1_insta_DimDepartments

Dim table for Instacart departments data.

| Column         | Description                          | Tests                                |
|----------------|--------------------------------------|--------------------------------------|
| department_id  | Unique identifier for each department| not_null, unique, not_negative       |
| department     | Department name                      | not_null                             |

---

#### 🧱 g1_insta_DimProducts

Dim table for Instacart products data.

| Column         | Description                          | Tests                                |
|----------------|--------------------------------------|--------------------------------------|
| product_id     | Unique identifier for each product    | not_null, unique, not_negative       |
| product_name   | Name of the product                   | not_null                             |

---

#### 🧱 g1_insta_DimUsers

Dim list of users extracted from the orders table.

| Column     | Description             | Tests                                |
|------------|-------------------------|--------------------------------------|
| user_id    | Primary key for users   | not_null, unique, not_negative       |

---

#### 📊 g1_insta_FactOrders

Fact orders data with user linkage and standardized types.

| Column                | Description                                                                 | Tests                                                                 |
|-----------------------|-----------------------------------------------------------------------------|-----------------------------------------------------------------------|
| order_id              | Foreign key for orders                                                      | not_null, not_negative, relationships → g1_stg_insta_order_products.order_id |
| user_id               | Foreign key referencing g1_stg_insta_users.user_id                          | not_null, not_negative, relationships → g1_stg_insta_users.user_id          |
| order_number          | Sequential order number per user                                            | not_null, not_negative                                               |
| order_dow             | Day of week order was placed (0=Sunday ... 6=Saturday)                      | not_null, accepted_values: [0–6]                                     |
| order_hour_of_day     | Hour of day order was placed (0–23)                                         | not_null, accepted_values: [0–23]                                    |
| days_since_prior_order| Days since previous order; may contain null (NaN) for first orders          | nullable                                                             |
| aisle_id              | Foreign key for each aisle ID                                               | not_null, not_negative, relationships → g1_stg_insta_order_aisles.aisle_id  |
| department_id         | Foreign key for each department ID                                          | not_null, not_negative, relationships → g1_stg_insta_departments.department_id |
| product_id            | Foreign key for each product ID                                             | not_null, not_negative, relationships → g1_stg_insta_products.product_id     |

---

### ✅ Add a small `schema.yml` for docs

##### Sample schema.yml for orders table
```yaml
version: 2

models:
  - name: g1_stg_insta_orders
    description: "Cleaned orders data with user linkage and standardized types."
    columns:
      - name: order_id
        description: "Primary key for orders."
        tests:
          - not_null
          - unique
          - not_negative:
              column_name: order_id

      - name: user_id
        description: "Foreign key referencing g1_stg_insta_users.user_id."
        tests:
          - not_null
          - relationships:
              to: ref('g1_stg_insta_users')
              field: user_id

      - name: eval_set
        description: "Evaluation set type (prior/train/test)."
        tests:
          - not_null
          - accepted_values:
              values: ['prior', 'train', 'test']

      - name: order_number
        description: "Sequential order number per user."
        tests:
          - not_null

      - name: order_dow
        description: "Day of week order was placed (0=Sunday ... 6=Saturday)."
        tests:
          - not_null
          - accepted_values:
              values: [0, 1, 2, 3, 4, 5, 6]

      - name: order_hour_of_day
        description: "Hour of day order was placed (0–23)."
        tests:
          - not_null
          - accepted_values:
              values: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

      - name: days_since_prior_order
        description: "Days since previous order; may contain null (NaN) for first orders."
```
---

#### ✅ Sample snippet of DQ check using SQL

```sql
ftw-de-bootcamp/dbt/transforms/01_instacart/models/
```

##### DQ Orders Summary:
```
{{ config(
    materialized = "view",
    schema = "mart"
) }}

with rawDs as (
  select * from {{ source('raw','raw___insta_orders') }}
),

cln as (
  select * from {{ ref('g1_stg_insta_orders') }}
),

counts as (
  select
    (select count() from rawDs)  as row_count_raw,
    (select count() from cln)    as row_count_clean
),

nulls as (
  select
    round(100.0 * countIf(order_id is null) / nullif(count(),0), 2) as null_pct_order_id,
    round(100.0 * countIf(user_id is null) / nullif(count(),0), 2) as null_pct_user_id,
    round(100.0 * countIf(eval_set is null) / nullif(count(),0), 2) as null_pct_eval_set,
    round(100.0 * countIf(order_number is null) / nullif(count(),0), 2) as null_pct_order_number,
    round(100.0 * countIf(order_dow is null) / nullif(count(),0), 2) as null_pct_order_dow,
    round(100.0 * countIf(order_hour_of_day is null) / nullif(count(),0), 2) as null_pct_order_hour_of_day,
    round(100.0 * countIf(days_since_prior_order is null) / nullif(count(),0), 2) as null_pct_days_since_prior_order
  from cln
),

dupes as (
  select
    countIf(cnt > 1) as duplicate_orders
  from (
    select order_id, count() as cnt
    from cln
    group by order_id
  )
),

referential_integrity as (
  select
    countIf(o.user_id not in (select distinct user_id from {{ ref('g1_stg_insta_users') }})) as invalid_user_id
  from {{ ref('g1_stg_insta_orders') }} o
),

value_ranges as (
  select
    countIf(order_number < 1) as invalid_order_number,
    countIf(order_hour_of_day < 0 or order_hour_of_day > 23) as invalid_order_hour,
    countIf(days_since_prior_order < 0 or days_since_prior_order > 30) as invalid_days_since_prior_order
  from cln
),

joined as (
    select
        counts.row_count_raw,
        counts.row_count_clean,
        (counts.row_count_raw - counts.row_count_clean) as dropped_rows,
        nulls.*,
        dupes.duplicate_orders,
        referential_integrity.invalid_user_id,
        value_ranges.invalid_order_number,
        value_ranges.invalid_order_hour,
        value_ranges.invalid_days_since_prior_order
    from counts
    cross join nulls
    cross join dupes
    cross join referential_integrity
    cross join value_ranges
)
select * from joined
```
---

## 3) Run  tests

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt test --profiles-dir . --target local --static
```

```bash
- Test Result:
  PASS=79 WARN=0 ERROR=0 SKIP=0 TOTAL=79
```

## 4) ⚙️ Execute Models & Run Pipeline

1) Build all models (`staging` → `clean` → `mart`) in this module:

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt build --profiles-dir . --target local --static
```

## 5) 📖 Generate Documentation

Generate static HTML documentation for this dbt project:

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt docs generate --profiles-dir . --target local --static
```
Open: `ftw-de-bootcamp/dbt/transforms/01_instacart/target/static_index.html`


## 6) DQ Instacart Dashboard
#### [Metabase DQ dashboard](http://54.87.106.52:3001/dashboard/52-instacart?tab=72-dq-overall-health-score&text=)

---
## ✅ Summary

* **Tests:** run `dbt test` for data quality checks
* **Build:** run `dbt build` to execute models
* **Docs:** run `dbt docs generate` and open `target/static_index.html`








