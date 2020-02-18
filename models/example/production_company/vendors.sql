 {{ config(materialized='ephemeral') }}

SELECT v.city,
    'vendor'::text AS company_class,
    NULL::boolean AS connect_enabled,
    v.connect_status,
    v.created_at,
    v.description,
    v.employee_count,
    'vn'::text || v.id AS id,
    v.job_sheet_enabled,
    v.job_sheet_signature_required,
    v.labor_approval_flow,
    NULL::text AS labor_enabled,
    v.labor_fee_percentage,
    v.labor_msa,
    NULL::boolean AS labor_only,
    v.labor_requirements,
    v.logo_url,
    v.name,
    v.id::character varying AS native_id,
    ps.description AS payment_schedule,
    v.phone,
    v.state,
    v.status::character varying AS status,
    v.street,
    v.website_url,
    v.zipcode
   FROM {{ source('RAW_PLATFORM', 'VENDORS') }} v
     LEFT JOIN {{ source('RAW_PLATFORM', 'SUBCONTRACTOR_PAYMENT_SCHEDULES') }} ps ON ps.id = v.subcontractor_payment_schedule_id