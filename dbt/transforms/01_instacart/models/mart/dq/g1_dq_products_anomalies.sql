{{ config(materialized="view", schema="mart") }}

select
  countIf(product_id <= 0) as negative_product_id,
  countIf(aisle_id <= 0) as negative_aisle_id,
  countIf(department_id <= 0) as negative_department_id,
  countIf(product_name is null) as null_product_name
from {{ source('clean','g1_stg_insta_products') }}