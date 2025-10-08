{{ config(
    materialized = "table",
    schema = "clean",
    engine = "MergeTree()",
    order_by = "(order_id, product_id)"
) }}

select
  cast(order_id as Int64) as order_id,
  cast(product_id as Int64) as product_id,
  cast(add_to_cart_order as Int64) as add_to_cart_order,
  cast(reordered as Int64) as reordered
from {{ source('raw','raw___insta_order_products_prior') }}

union all

select
  cast(order_id as Int64) as order_id,
  cast(product_id as Int64) as product_id,
  cast(add_to_cart_order as Int64) as add_to_cart_order,
  cast(reordered as Int64) as reordered
from {{ source('raw','raw___insta_order_products_train') }}