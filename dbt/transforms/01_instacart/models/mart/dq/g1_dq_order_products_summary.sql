{{ config(materialized="view", schema="mart") }}

with raw_prior as (
  select * from {{ source('raw','raw___insta_order_products_prior') }}
),
raw_train as (
  select * from {{ source('raw','raw___insta_order_products_train') }}
),
raw_combined as (
  select * from raw_prior
  union all
  select * from raw_train
),
cln as (
  select * from {{ source('clean','g1_stg_insta_order_products') }}
),

counts as (
  select
    (select count() from raw_combined) as row_count_raw,
    (select count() from cln) as row_count_clean
),
nulls as (
  select
    round(100.0 * countIf(order_id is null) / nullif(count(),0), 2) as null_pct_order_id,
    round(100.0 * countIf(product_id is null) / nullif(count(),0), 2) as null_pct_product_id,
    round(100.0 * countIf(add_to_cart_order is null) / nullif(count(),0), 2) as null_pct_add_to_cart_order,
    round(100.0 * countIf(reordered is null) / nullif(count(),0), 2) as null_pct_reordered
  from cln
),
bounds as (
  select
    countIf(order_id <= 0) as negative_order_id,
    countIf(product_id <= 0) as negative_product_id,
    countIf(add_to_cart_order <= 0) as negative_add_to_cart_order,
    countIf(reordered not in (0, 1)) as invalid_reordered
  from cln
),
joined as (
  select
    counts.row_count_raw,
    counts.row_count_clean,
    (counts.row_count_raw - counts.row_count_clean) as dropped_rows,

    nulls.null_pct_order_id,
    nulls.null_pct_product_id,
    nulls.null_pct_add_to_cart_order,
    nulls.null_pct_reordered,

    bounds.negative_order_id,
    bounds.negative_product_id,
    bounds.negative_add_to_cart_order,
    bounds.invalid_reordered

  from counts
  cross join nulls
  cross join bounds
)

select * from joined