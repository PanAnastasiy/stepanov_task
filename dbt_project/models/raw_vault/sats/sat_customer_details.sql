{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['CUSTOMER_PK', 'LOAD_TIMESTAMP'],
    schema='raw_vault'
) }}

{%- set source_model = "stg_customers" -%}
{%- set src_pk = "CUSTOMER_PK" -%}
{%- set src_hashdiff = "CUSTOMER_HASHDIFF" -%}
{%- set src_payload = ['FIRST_NAME', 'LAST_NAME', 'EMAIL'] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_TIMESTAMP" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.sat(
    source_model=source_model,
    src_pk=src_pk,
    src_hashdiff=src_hashdiff,
    src_payload=src_payload,
    src_eff=src_eff,
    src_ldts=src_ldts,
    src_source=src_source
) }}

