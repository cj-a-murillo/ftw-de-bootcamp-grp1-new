{{ config(materialized="view", schema="mart") }}

with src as (
  select * from {{ source('raw', 'raw___insta_departments') }}
),
cln as (
  select * from {{ source('clean', 'g1_stg_insta_departments') }}
),

counts as (
  select
    (select count() from src)  as row_count_raw,
    (select count() from cln)  as row_count_clean
),
nulls as (
  select
    round(100.0 * countIf(department_id is null) / nullif(count(),0), 2) as pct_null_department_id,
    round(100.0 * countIf(department is null) / nullif(count(),0), 2)    as pct_null_department
  from cln
),
bounds as (
  select
    countIf(department_id <= 0)           as negative_department_id
  from cln
),
uniqueness as (
  select
    count() - countDistinct(department_id) as duplicate_department_id,
    count() - countDistinct(department)    as duplicate_department
  from cln
),
joined as (
  select
    counts.row_count_raw as row_count_raw,
    counts.row_count_clean as row_count_clean,
    (counts.row_count_raw - counts.row_count_clean) as dropped_rows,

    nulls.pct_null_department_id as pct_null_department_id,
    nulls.pct_null_department as pct_null_department,

    bounds.negative_department_id as negative_department_id,

    uniqueness.duplicate_department_id as duplicate_department_id,
    uniqueness.duplicate_department as duplicate_department

  from counts
  cross join nulls
  cross join bounds
  cross join uniqueness
)

select * from joined