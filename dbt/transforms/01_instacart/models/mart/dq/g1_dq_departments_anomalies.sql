{{ config(materialized="view", schema="mart") }}

-- Row-level drilldown of “obviously wrong” records based on simple rules.
-- LIMIT for demo-friendliness; remove in real pipelines.

with cln as (
  select * from {{ source('clean', 'g1_stg_insta_departments') }}
),
violations as (
  select
    -- NOTE: this dataset has no native PK; include a synthetic row_number if needed.
    -- ClickHouse: use monotonicallyIncreasingId() isn't stable; we’ll show columns directly.
    department_id, department,

    multiIf(
      department_id <= 0,       'negative_department_id',
      department is null,            'null_department',
      'ok'
    ) as dq_issue
  from cln
)
select *
from violations
where dq_issue != 'ok'