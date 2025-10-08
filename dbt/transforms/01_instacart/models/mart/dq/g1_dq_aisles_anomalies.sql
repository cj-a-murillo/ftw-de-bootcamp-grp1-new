{{ config(materialized="view", schema="mart") }}

-- Row-level drilldown of “obviously wrong” records based on simple rules.
-- LIMIT for demo-friendliness; remove in real pipelines.

with cln as (
  select * from {{ source('clean', 'g1_stg_insta_aisles') }}
),
violations as (
  select
    -- NOTE: this dataset has no native PK; include a synthetic row_number if needed.
    -- ClickHouse: use monotonicallyIncreasingId() isn't stable; we’ll show columns directly.
    aisle_id, aisle,

    multiIf(
      aisle_id <= 0,                              'negative_aisle_id',
      aisle_id is null,                           'null_aisle_id',
      count(*) over (partition by aisle_id) > 1,  'duplicate_aisle_id',
      aisle is null,                              'null_aisle',
      count(*) over (partition by aisle) > 1,     'duplicate_aisle',
      'ok'
    ) as dq_issue
  from cln
)
select *
from violations
where dq_issue != 'ok'
limit 50
