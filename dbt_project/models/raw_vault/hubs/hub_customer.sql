{{ config(
    materialized='table'
) }}

SELECT DISTINCT
    customer_id AS hub_customer_id
FROM {{ ref('stg_orders') }}
