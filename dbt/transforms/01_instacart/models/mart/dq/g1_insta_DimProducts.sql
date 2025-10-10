{{ config(
    materialized = "table",
    alias = "g1_insta_DimProducts",
    schema = "mart",
    tags = ["mart","insta"]
) }}

with products as (
  select
    cast(product_id as Int64) as product_id,
    cast(product_name as String) as product_name
  from {{ ref('g1_stg_insta_products') }}
)

select distinct
  product_id,
  product_name
from products
where product_id is not null
order by product_id