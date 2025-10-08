{{ config(
    materialized = "view",
    schema = "mart"
) }}

-- Row-level Data Quality Violations for Orders
with cln as (
  -- Source cleaned orders data
  select * 
  from {{ ref('g1_stg_insta_orders') }}
),

users as (
  -- Reference users table for FK validation
  select user_id 
  from {{ ref('g1_stg_insta_users') }}
),

violations as (
  select
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order,

    -- Data Quality Issue Classification
    multiIf(
      order_id is null, 'null_order_id',
      user_id is null, 'null_user_id',
      user_id not in (select user_id from users), 'missing_user_ref',
      order_number < 1, 'invalid_order_number',
      order_dow not in (0,1,2,3,4,5,6), 'invalid_order_dow',
      order_hour_of_day < 0 or order_hour_of_day > 23, 'invalid_order_hour',
      days_since_prior_order < 0, 'negative_days_since_prior_order',
      'ok'
    ) as dq_issue

  from cln
)

-- Return only rows with detected anomalies
select *
from violations
where dq_issue != 'ok'
limit 100
