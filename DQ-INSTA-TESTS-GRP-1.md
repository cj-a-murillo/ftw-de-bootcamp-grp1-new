# 🚀 FTW Data Engineering Bootcamp – Instacart Staging Models (dbt)

This module defines the clean staging layer for the Instacart dataset using **dbt**. It includes:

- Structured staging models (`g1_stg_insta_*`)
- Column-level dbt tests (structural + referential)
- Optional dashboard scaffolding for data quality (Metabase-ready)
- Auto-generated dbt docs 
---

## 📂 Folder Structure

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
    │   └── test_not_negative_id.sql      # test for checking negative int (after generation)
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
    │       └── dq/
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
## 🧪 dbt Tests – Staging Layer

This section documents the column-level tests applied to the Instacart staging models (`g1_stg_insta_*`). 
These tests ensure structural integrity, enforce domain constraints, and validate foreign key relationships.

**Defined in:** `models/clean/schema.yml`

---

## 🧱 Model Test Matrix

### `g1_stg_insta_aisles`

| Column     | Tests                                  |
|------------|----------------------------------------|
| `aisle_id` | `not_null`, `unique`, `not_negative`   |
| `aisle`    | `not_null`                             |

---

### `g1_stg_insta_departments`

| Column         | Tests                                 |
|----------------|----------------------------------------|
| `department_id`| `not_null`, `unique`, `not_negative`   |
| `department`   | `not_null`                             |

---

### `g1_stg_insta_products`

| Column         | Tests                                                                  |
|----------------|------------------------------------------------------------------------|
| `product_id`   | `not_null`, `unique`, `not_negative`                                   |
| `product_name` | `not_null`                                                             |
| `aisle_id`     | `not_null`, `relationships → g1_stg_insta_aisles.aisle_id`             |
| `department_id`| `not_null`, `relationships → g1_stg_insta_departments.department_id`   |

---

### `g1_stg_insta_order_products`

| Column             | Tests                                                                          |
|--------------------|--------------------------------------------------------------------------------|
| `order_id`         | `not_null`, `not_negative`, `relationships → g1_stg_insta_orders.order_id`     |
| `product_id`       | `not_null`, `not_negative`, `relationships → g1_stg_insta_products.product_id` |
| `add_to_cart_order`| `not_null`, `not_negative`                                                     |
| `reordered`        | `not_null`, `accepted_values: [0, 1]`                                          |

---

### `g1_stg_insta_users`

| Column    | Tests                                  |
|-----------|----------------------------------------|
| `user_id` | `not_null`, `unique`, `not_negative`   |

---

### `g1_stg_insta_orders`

| Column                | Tests                                                                  |
|-----------------------|------------------------------------------------------------------------|
| `order_id`            | `not_null`, `unique`, `not_negative`                                   |
| `user_id`             | `not_null`, `relationships → g1_stg_insta_users.user_id`               |
| `eval_set`            | `accepted_values: ['prior', 'train', 'test']`                          |
| `order_number`        | `not_null`                                                             |
| `order_dow`           | `accepted_values: [0–6]`                                               |
| `order_hour_of_day`   | `accepted_values: [0–23]`                                              |
| `days_since_prior_order` | nullable (first orders may be null)                                 |


## 🧪 Running dbt Tests

### Clean (structural tests)

* Validate not-null constraints, accepted values, and referential integrity tests.
* Defined in: `models/clean/schema.yml`

### Mart (semantic tests)

* Validate not-null constraints, accepted values, and referential integrity tests.
* Defined in: `models/mart/schema.yml`

**Run tests:**

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt test --profiles-dir . --target local
```

---

## ⚙️ Execute Models & Run Pipeline

Build all models (`staging` → `clean` → `mart`) in this module:

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt build --profiles-dir . --target local
```

---

## 📖 Generate Documentation

Generate static HTML documentation for this dbt project:

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt docs generate --profiles-dir . --target local --static
```


## ✅ Summary

* **Tests:** run `dbt test` for data quality checks
* **Build:** run `dbt build` to execute models
* **Docs:** run `dbt docs generate` and open `target/index.html`

---

## 1) Add dbt models (mart layer)

Create a new folder:

```sql
ftw-de-bootcamp/dbt/transforms/01_mpg/models/mart/dq/
```
### ✅ Sample snippet of DQ check:

#### DQ Orders Summary:
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
## 🧪 Custom dbt Test – `test_not_negative`

This macro defines a reusable test to validate that a given column in a model does **not contain negative values**. 
It’s useful for enforcing domain constraints on identifiers, metrics, or any field expected to be zero or positive.

---

### 📄 Macro Definition

**Path:** `dbt/transforms/01_instacart/macros/test_not_negative_id.sql`

```sql
{% test not_negative(model, column_name) %}
SELECT *
FROM {{ model }}
WHERE {{ column_name }} < 0
{% endtest %}
```
---

### ✅ Add a small `schema.yml` for docs

**Path:** `ftw-de-bootcamp/dbt/transforms/01_mpg/models/mart/dq/schema.yml`

#### Sample schema.yml for orders
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

## ✅ Build the models

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt build --profiles-dir . --target local
```

Generate/update docs (optional, nice for students):

```bash
docker compose --profile jobs run --rm \
  -w /workdir/transforms/01_instacart \
  dbt docs generate --profiles-dir . --target local --static
```

Open: `ftw-de-bootcamp/dbt/transforms/01_instacart/target/index.html`

---


