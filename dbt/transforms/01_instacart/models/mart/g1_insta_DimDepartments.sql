{{ config(
    materialized = "table",
    schema = "mart",
    tags = ["mart", "instacart"]
) }}

-- Department dimension (DimDepartments)

with dept as (
    select * from {{ source('clean', 'g1_stg_insta_departments') }}
)

select
    department_id,
    department
from dept
order by department_id
