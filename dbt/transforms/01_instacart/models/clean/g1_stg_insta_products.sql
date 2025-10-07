{{ config(
    materialized = "table",
    schema = "clean",
    engine = "MergeTree()",
    order_by = "product_id"
) }}

select
  cast(product_id as Int64) as product_id,
  cast(product_name as String) as product_name,
  cast(aisle_id as Int64) as aisle_id,
  cast(department_id as Int64) as department_id
from {{ source('raw','raw___insta_products') }}