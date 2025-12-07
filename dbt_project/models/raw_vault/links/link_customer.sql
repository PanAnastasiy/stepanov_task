{{ config(
    materialized='table'
) }}

SELECT
    o.order_id,
    c.hub_customer_id
FROM {{ ref('stg_orders') }} AS o
JOIN {{ ref('hub_customer') }} AS c
ON o.customer_id = c.hub_customer_id
