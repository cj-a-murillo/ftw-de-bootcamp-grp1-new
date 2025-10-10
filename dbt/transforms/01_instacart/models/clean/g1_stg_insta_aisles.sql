{{ config(
    materialized="table", 
    schema="clean", 
    oder_by = "aisle_id",
    tags=["staging","insta"]
) }}

-- Keep album grain; standardize names/types.
select
  cast(aisle_id as Int64) as aisle_id,
  cast(aisle as String) as aisle
from {{ source('raw', 'raw___insta_aisles') }}
