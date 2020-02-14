{{ config(schema='johnhageman') }}

select user_id, count(*) as row_count from {{ source('RAW_PLATFORM', 'ENDEAVOR_ASSIGNMENTS') }}
group by user_id