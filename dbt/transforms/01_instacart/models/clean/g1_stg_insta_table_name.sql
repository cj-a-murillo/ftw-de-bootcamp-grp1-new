{{ config(materialized="table", schema="clean") }}

-- Source columns are already Nullable with correct types.
-- Keep them as-is to preserve nullability and avoid insert errors.


