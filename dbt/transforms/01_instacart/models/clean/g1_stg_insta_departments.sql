{{ config(
    materialized="table", 
    schema="clean", 
    engine = "MergeTree()",
    oder_by = "department_id",
    tags=["staging","insta"]
) }}

-- Keep album grain; standardize names/types.
select
  cast(department_id as Int64) as department_id,
  cast(department as String) as department
from {{ source('raw', 'raw___insta_departments') }}
