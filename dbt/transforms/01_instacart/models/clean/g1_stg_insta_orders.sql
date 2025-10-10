{{ config(
    materialized = "table",
    schema = "clean",
    engine = "MergeTree()",
    order_by = "order_id",
    tags=["staging","insta"]
) }}

-- Clean layer: Orders table
-- Purpose: Standardize data types and preserve NaN values for numeric continuity.
-- Primary Key: order_id
-- Foreign Key: user_id → g1_stg_insta_users.user_id

select
  cast(order_id as Int64)               as order_id,
  cast(user_id as Int64)                as user_id,
  cast(eval_set as String)              as eval_set,
  cast(order_number as Int64)           as order_number,
  cast(order_dow as Int64)              as order_dow,
  cast(order_hour_of_day as Int64)      as order_hour_of_day,
  cast(days_since_prior_order as Float64) as days_since_prior_order
from {{ source('raw', 'raw___insta_orders') }}
