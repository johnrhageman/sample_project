{{ config(materialized='table') }}

SELECT u.activated_at,
    p.availability_status,
    p.city,
    {{ get_company_class('u.operator_id', 'u.vendor_id') }} AS company_class,
    {{ get_company_id('u.operator_id', 'u.vendor_id') }} AS company_id,
    {{ get_company_name('u.operator_id', 'u.vendor_id') }} AS company_name,
    {{ get_company_native_id('u.operator_id', 'u.vendor_id') }} AS company_native_id,
    p.country,
    u.created_at,
    u.current_sign_in_at,
    p.date_of_birth,
    p.eligibility_status,
    u.email,
    p.headline,
    u.id,
    p.initial_use_case,
    p.introduced_by,
    p.introduced_through,
    {{ get_is_rigup() }} AS is_rigup,
    u.last_active_date,
    u.last_sign_in_at,
    u.linkedin_url,
    p.marketplace_status,
    u.name,
    u.office_phone,
    p.onboarding_status,
    u.operational_role,
    u.origin,
    u.phone,
    p.id AS profile_id,
    p.profile_status,
    u.referral_code,
    u.role,
    u.rua_description,
    u.sign_in_count,
    u.source,
    p.state,
    u.status,
    p.street_address,
    {{ get_user_class() }} AS user_class,
    p.zipcode
   FROM {{ source('RAW_PLATFORM', 'USERS') }} u
     LEFT JOIN {{ source('RAW_PLATFORM', 'SUBCONTRACTOR_PROFILES') }} p ON p.user_id = u.id
     LEFT JOIN {{ source('RAW_PLATFORM', 'OPERATORS') }} o ON u.operator_id = o.id
     LEFT JOIN {{ source('RAW_PLATFORM', 'VENDORS') }} v ON u.vendor_id = v.id
     