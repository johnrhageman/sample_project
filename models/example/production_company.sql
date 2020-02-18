{{ config(materialized='table') }}

SELECT * FROM {{ ref('operators') }}
UNION
SELECT * FROM {{ ref('vendors') }}