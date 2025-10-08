{{ config(materialized="view", schema="mart") }}


with clean as (
  select *
  from {{ source('clean','g1_stg_insta_order_products') }}
),
violations as (
  select
    order_id,
    product_id,
    add_to_cart_order,
    reordered,
    multiIf(
      order_id <= 0, 'nonpositive_order_id',
      product_id <= 0, 'nonpositive_product_id',
      add_to_cart_order <= 0, 'nonpositive_add_to_cart_order',
      reordered not in (0, 1), 'invalid_reordered',
      order_id is null, 'null_order_id',
      product_id is null, 'null_product_id',
      'ok'
    ) as dq_issue
  from clean
)
select *
from violations
where dq_issue != 'ok'


