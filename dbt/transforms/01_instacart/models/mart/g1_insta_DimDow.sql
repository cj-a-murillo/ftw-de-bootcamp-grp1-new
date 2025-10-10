{{ config(
    materialized = "table",
    schema = "mart",
    tags = ["mart", "instacart"]
) }}

-- Day of Week dimension (DimDow)

with dow as (
    select
        distinct order_dow
    from {{ source('clean', 'g1_stg_insta_orders') }}
)

select
    order_dow,
    case order_dow
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
        else 'Unknown'
    end as day
from dow
order by order_dow
