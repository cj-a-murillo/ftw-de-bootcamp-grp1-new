{{ config(materialized="view", schema="mart") }}

select
  countIf(order_id <= 0) as negative_order_id,
  countIf(product_id <= 0) as negative_product_id,
  countIf(add_to_cart_order <= 0) as negative_add_to_cart_order,
  countIf(reordered not in (0, 1)) as invalid_reordered,
  countIf(order_id is null) as null_order_id,
  countIf(product_id is null) as null_product_id
from {{ source('clean','g1_stg_insta_order_products') }}