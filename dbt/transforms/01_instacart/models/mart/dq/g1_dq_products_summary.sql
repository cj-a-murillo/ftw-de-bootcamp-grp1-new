{{ config(materialized="view", schema="mart") }}

with rawDs as (
  select * from {{ source('raw','raw___insta_products') }}
),
cln as (
  select * from {{ source('clean','g1_stg_insta_products') }}
),

counts as (
  select
    (select count() from rawDs)  as row_count_raw,
    (select count() from cln)  as row_count_clean
),
nulls as (
  select
    round(100.0 * countIf(product_id is null) / nullif(count(),0), 2) as null_pct_product_id,      /*    Null % = (total null rows / total rows) * 100    */
    round(100.0 * countIf(product_name is null) / nullif(count(),0), 2) as null_pct_product_name,
    round(100.0 * countIf(aisle_id is null) / nullif(count(),0), 2) as null_pct_aisle_id,
    round(100.0 * countIf(department_id is null) / nullif(count(),0), 2) as null_pct_department_id
  from cln
),
bounds as (
  select
    countIf(product_id <= 0)           as negative_product_id,
    countIf(aisle_id <= 0)             as negative_aisle_id,
    countIf(department_id <= 0)        as negative_department_id
  from cln
),
joined as (
  select
    counts.row_count_raw as row_count_raw,
    counts.row_count_clean as row_count_clean,
    (counts.row_count_raw - counts.row_count_clean) as dropped_rows,

    nulls.null_pct_product_id as null_pct_product_id,
    nulls.null_pct_product_name as null_pct_product_name,
    nulls.null_pct_aisle_id as null_pct_aisle_id,
    nulls.null_pct_department_id as null_pct_department_id,

    bounds.negative_product_id as negative_product_id,
    bounds.negative_aisle_id as negative_aisle_id,
    bounds.negative_department_id as negative_department_id

  from counts
  cross join nulls
  cross join bounds
)

select * from joined
