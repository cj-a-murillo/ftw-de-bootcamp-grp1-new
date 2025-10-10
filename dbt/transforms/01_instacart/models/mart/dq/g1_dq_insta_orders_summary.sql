{{ config(
    materialized = "view",
    schema = "mart"
) }}

-- Data Quality Summary for Orders
-- Tracks: row counts, null %, duplicates, referential integrity, value ranges

with rawDs as (
  select * from {{ source('raw','raw___insta_orders') }}
),

cln as (
  select * from {{ ref('g1_stg_insta_orders') }}
),

-- Row Count Comparison
counts as (
  select
    (select count() from rawDs)  as row_count_raw,
    (select count() from cln)    as row_count_clean
),

-- Null Percentage Check
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

-- Duplicate Orders
dupes as (
  select
    countIf(cnt > 1) as duplicate_orders
  from (
    select order_id, count() as cnt
    from cln
    group by order_id
  )
),

-- Referential Integrity
referential_integrity as (
  select
    countIf(o.user_id not in (select distinct user_id from {{ ref('g1_stg_insta_users') }})) as invalid_user_id
  from {{ ref('g1_stg_insta_orders') }} o
),

-- Value Range Checks
value_ranges as (
  select
    countIf(order_number < 1) as invalid_order_number,
    countIf(order_hour_of_day < 0 or order_hour_of_day > 23) as invalid_order_hour,
    countIf(days_since_prior_order < 0 or days_since_prior_order > 30) as invalid_days_since_prior_order
  from cln
),

-- Join all metrics
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