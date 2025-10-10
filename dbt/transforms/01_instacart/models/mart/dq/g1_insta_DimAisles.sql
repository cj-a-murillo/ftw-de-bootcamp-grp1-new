{{ config(
    materialized = "table",
    alias = "g1_insta_DimAisles",
    schema = "mart",
    tags = ["mart","insta"]
) }}

with aisles as (
  select
    cast(aisle_id as Int64) as aisle_id,
    cast(aisle as String) as aisle
  from {{ ref('g1_stg_insta_aisles') }}
)

select distinct
  aisle_id,
  aisle
from aisles
where aisle_id is not null
order by aisle_id