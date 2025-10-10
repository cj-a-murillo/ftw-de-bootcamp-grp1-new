{{ config(materialized="view", schema="mart") }}

-- Row-level drilldown of “obviously wrong” records based on simple rules.
-- LIMIT for demo-friendliness; remove in real pipelines.

with cln as (
  select *
  from {{ ref('g1_stg_insta_products') }}
),
violations as (
  select
    product_id,
    aisle_id,
    department_id,
    product_name,
    multiIf(
      product_id <= 0, 'nonpositive_product_id',
      aisle_id <= 0, 'nonpositive_aisle_id',
      department_id <= 0, 'nonpositive_department_id',
      product_name is null, 'null_product_name',
      'ok'
    ) as dq_issue
  from cln
)
select *
from violations
where dq_issue != 'ok'