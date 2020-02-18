SELECT a.accounting_rate_id,
    a.subject_id,
    a.subject_type,
    a.company_class,
    a.company_id,
    a.native_id,
    a.company_name,
    a.pay_type,
    a.fee_type,
    a.take_rate,
    a.accounting_type,
    a.take_rate_set_id,
    a.created_at,
    a.contractor_id
   FROM ( SELECT DISTINCT r.id AS accounting_rate_id,
            rs.subject_id,
            rs.subject_type,
            c.company_class,
            c.id AS company_id,
            c.native_id,
            c.name AS company_name,
            r.field_name AS pay_type,
            r.name AS fee_type,
            r.value AS take_rate,
                CASE
                    WHEN rs.type::text = 'LaborAccounting::LaborReceivableRateSet'::text THEN 'Labor_Accounting_Receivable'::text
                    WHEN rs.type::text = 'Accounting::LaborReceivableRateSet'::text THEN 'Accounting_Receivable'::text
                    ELSE NULL::text
                END AS accounting_type,
            rs.id AS take_rate_set_id,
            r.created_at,
            NULL::text AS contractor_id
           FROM {{ source('RAW_PLATFORM', 'LABOR_ACCOUNTING_RATES') }} r
             LEFT JOIN {{ source('RAW_PLATFORM', 'LABOR_ACCOUNTING_RATE_SETS') }} rs ON r.rate_set_id = rs.id
             JOIN {{ ref('production_company') }} c ON {{ array_contains_column ('rs.subject_type', ['VENDOR', 'OPERATOR']) }} AND rs.subject_id = c.native_id::integer AND lower(rs.subject_type::text) = c.company_class
        UNION
         SELECT DISTINCT r.id AS accounting_rate_id,
            rs.subject_id,
                CASE
                    WHEN {{ array_contains_column ('rs.subject_type', ['Subcontractor::Job', 'Subcontractor::Affiliation']) }} THEN 'Contractor'::text
                    ELSE NULL::text
                END AS subject_type,
            c.company_class AS company_type,
            c.id AS company_id,
            c.native_id,
            c.name AS company_name,
            r.field_name AS pay_type,
            r.name AS fee_type,
            r.value AS take_rate,
                CASE
                    WHEN rs.type::text = 'LaborAccounting::LaborPayableRateSet'::text THEN 'Labor_Accounting_Payable'::text
                    ELSE NULL::text
                END AS accounting_type,
            rs.id AS take_rate_set_id,
            r.created_at,
            u.id::text AS contractor_id
           FROM {{ source('RAW_PLATFORM', 'LABOR_ACCOUNTING_RATES') }} r
             LEFT JOIN {{ source('RAW_PLATFORM', 'LABOR_ACCOUNTING_RATE_SETS') }} rs ON r.rate_set_id = rs.id
             LEFT JOIN {{ source('RAW_PLATFORM', 'SUBCONTRACTOR_JOBS') }} j ON j.id = rs.subject_id
             LEFT JOIN {{ ref('production_user') }} u ON u.profile_id = j.profile_id
             LEFT JOIN {{ ref('production_company') }} c ON j.company_id::text = c.native_id::text AND lower(j.company_type::text) = c.company_class
          WHERE rs.subject_type::text = 'Subcontractor::Affiliation'::text) a
  ORDER BY a.accounting_rate_id