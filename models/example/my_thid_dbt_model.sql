{{ config(schema='johnhageman') }}

select user_id, count(*) as row_count from "RAW"."PLATFORM_REPLICA_PUBLIC"."ENDEAVOR_ASSIGNMENTS"
group by user_id