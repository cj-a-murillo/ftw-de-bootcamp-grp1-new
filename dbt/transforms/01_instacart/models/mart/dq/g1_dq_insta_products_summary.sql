{{ config( materialized = "view", schema = "mart") }}

-- Data Quality Summary for Products
-- Checks: Row counts, null %, duplicates, referential integrity, and value bounds

WITH raw_ds AS (
    SELECT * FROM {{ source('raw', 'raw___insta_products') }}
),

cln AS (
    SELECT * FROM {{ ref('g1_stg_insta_products') }}
),

--  Row Count Comparison
counts AS (
    SELECT
        (SELECT COUNT() FROM raw_ds)  AS row_count_raw_products,
        (SELECT COUNT() FROM cln)     AS row_count_clean_products
),

--  Null Percentage Check
nulls AS (
    SELECT
        ROUND(100.0 * countIf(product_id IS NULL) / NULLIF(count(), 0), 2)       AS null_pct_product_id,
        ROUND(100.0 * countIf(product_name IS NULL) / NULLIF(count(), 0), 2)     AS null_pct_product_name,
        ROUND(100.0 * countIf(aisle_id IS NULL) / NULLIF(count(), 0), 2)         AS null_pct_aisle_id,
        ROUND(100.0 * countIf(department_id IS NULL) / NULLIF(count(), 0), 2)    AS null_pct_department_id
    FROM cln
),

--  Duplicate Check
dupes AS (
    SELECT
        COUNTIf(cnt > 1) AS duplicate_product_id_count
    FROM (
        SELECT product_id, COUNT() AS cnt
        FROM cln
        GROUP BY product_id
    )
),

--  Referential Integrity Check
referential_integrity AS (
    SELECT
        COUNTIf(p.aisle_id NOT IN (SELECT DISTINCT aisle_id FROM {{ ref('g1_stg_insta_aisles') }}))        AS invalid_fk_aisle_id_count,
        COUNTIf(p.department_id NOT IN (SELECT DISTINCT department_id FROM {{ ref('g1_stg_insta_departments') }})) AS invalid_fk_department_id_count
    FROM {{ ref('g1_stg_insta_products') }} p
),

--  Value Bounds Check
bounds AS (
    SELECT
        COUNTIf(product_id <= 0)       AS invalid_product_id_count,
        COUNTIf(aisle_id <= 0)         AS invalid_aisle_id_count,
        COUNTIf(department_id <= 0)    AS invalid_department_id_count
    FROM cln
),

--  Combine All Metrics
joined AS (
    SELECT
        counts.row_count_raw_products as row_count_raw,
        counts.row_count_clean_products as row_count_clean,
        (counts.row_count_raw_products - counts.row_count_clean_products) AS dropped_rows,

        nulls.null_pct_product_id as null_pct_product_id,
        nulls.null_pct_product_name as null_pct_product_name,
        nulls.null_pct_aisle_id as null_pct_aisle_id,
        nulls.null_pct_department_id as null_pct_department_id,

        dupes.duplicate_product_id_count AS duplicate_product_id_count,
        referential_integrity.invalid_fk_aisle_id_count AS invalid_fk_aisle_id_count,
        referential_integrity.invalid_fk_department_id_count  AS invalid_fk_department_id_count,

        bounds.invalid_product_id_count AS invalid_product_id_count,
        bounds.invalid_aisle_id_count AS invalid_aisle_id_count,
        bounds.invalid_department_id_count AS invalid_department_id_count
    FROM counts
    CROSS JOIN nulls
    CROSS JOIN dupes
    CROSS JOIN referential_integrity
    CROSS JOIN bounds
)

SELECT * FROM joined
