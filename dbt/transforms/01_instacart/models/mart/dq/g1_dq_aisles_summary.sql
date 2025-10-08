{{ config(materialized="view", schema="mart") }}

with src as (
  select * from {{ source('raw', 'raw___insta_aisles') }}
),
cln as (
  select * from {{ source('clean', 'g1_stg_insta_aisles') }}
),

counts as (
  select
    (select count() from src)  as row_count_raw,
    (select count() from cln)  as row_count_clean
),
nulls as (
  select
    round(100.0 * countIf(aisle_id is null) / nullif(count(),0), 2) as pct_null_aisle_id,
    round(100.0 * countIf(aisle is null) / nullif(count(),0), 2)    as pct_null_aisle
  from cln
),
bounds as (
  select
    countIf(aisle_id <= 0)           as negative_aisle_id
  from cln
),
uniqueness as (
  select
    count() - countDistinct(aisle_id) as duplicate_aisle_id,
    count() - countDistinct(aisle)    as duplicate_aisle
  from cln
),
joined as (
  select
    counts.row_count_raw as row_count_raw,
    counts.row_count_clean as row_count_clean,
    (counts.row_count_raw - counts.row_count_clean) as dropped_rows,

    nulls.pct_null_aisle_id as pct_null_aisle_id,
    nulls.pct_null_aisle as pct_null_aisle,

    bounds.negative_aisle_id as negative_aisle_id,

    uniqueness.duplicate_aisle_id as duplicate_aisle_id,
    uniqueness.duplicate_aisle as duplicate_aisle

  from counts
  cross join nulls
  cross join bounds
  cross join uniqueness
)

select * from joined