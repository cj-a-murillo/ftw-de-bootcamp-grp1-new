{{ config(
    materialized = "table",
    schema = "mart",
    tags = ["mart", "instacart"]
) }}

-- Dimension: Users
-- Purpose: User dimension derived from the clean layer (distinct users)
-- Primary Key: user_id

with users as (
    select
        user_id
    from {{ source('clean', 'g1_stg_insta_users') }}
)

select
    user_id
from users