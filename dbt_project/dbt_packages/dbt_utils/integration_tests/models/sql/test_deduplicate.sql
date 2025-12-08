with

source as (
    select *
    from {{ ref('data_deduplicate') }}
    where user_id = 1
),

deduped as (

    {{
        dbt_utils.deduplicate(
            'source.yml',
            partition_by='user_id',
            order_by='version desc',
        ) | indent
    }}

)

select * from deduped
