{{ config(materialized='incremental') }}

SELECT DISTINCT
    ORDER_PK,
    ORDER_ID,
    LOAD_DATE,
    RECORD_SOURCE
FROM {{ ref('stg_tpch_orders') }}
    {% if is_incremental() %}
WHERE LOAD_DATE > (SELECT MAX(LOAD_DATE) FROM {{ this }})
    {% endif %}