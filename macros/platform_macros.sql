{% macro get_company_class(operator_id_col, vendor_id_col) %}
    CASE
        WHEN {{ operator_id_col }} IS NOT NULL THEN 'operator'::text
        WHEN {{ vendor_id_col }} IS NOT NULL THEN 'vendor'::text
        ELSE NULL::text
    END
{% endmacro %}

{% macro get_company_id(operator_id_col, vendor_id_col) %}
    CASE
        WHEN {{ operator_id_col }} IS NOT NULL THEN 'op'::text || u.operator_id
        WHEN {{ vendor_id_col }} IS NOT NULL THEN 'vn'::text || u.vendor_id
        ELSE NULL::text
    END
{% endmacro %}

{% macro get_company_name(operator_id_col, vendor_id_col) %}
    CASE
        WHEN {{ operator_id_col }} IS NOT NULL THEN o.name
        WHEN {{ vendor_id_col }} IS NOT NULL THEN v.name
        ELSE NULL::character varying
    END
{% endmacro %}

{% macro get_company_native_id(operator_id_col, vendor_id_col) %}
    CASE
        WHEN {{ operator_id_col }} IS NOT NULL THEN u.operator_id
        WHEN {{ vendor_id_col }} IS NOT NULL THEN u.vendor_id
        ELSE NULL::integer
    END    
{% endmacro %}

{% macro get_user_class() %}
    CASE
        WHEN p.id IS NOT NULL THEN 'contractor'::text
        WHEN u.operator_id IS NOT NULL THEN 'operator'::text
        WHEN u.vendor_id IS NOT NULL THEN 'vendor'::text
        WHEN ARRAY_CONTAINS('data_entry'::VARIANT, application_roles) THEN 'rua'::text
        ELSE 'invalid'::text
    END
{% endmacro %}

{% macro get_is_rigup() %}
    CASE
        WHEN u.origin = 'internal' THEN true
        WHEN ARRAY_CONTAINS('data_entry'::VARIANT, application_roles) THEN true
        ELSE false
    END 
{% endmacro %}

{%- macro generate_case_statement(case_and_values_dict, else_value) -%}
    CASE 
    {%- for key, value in case_and_values_dict.items() %}
        WHEN {{ key }} THEN {{ value }}
    {%- endfor %}
    ELSE
        {{ else_value }}
    END
{% endmacro %}

{% macro array_contains_column (column_name, values_list) %}
    ARRAY_CONTAINS(
        {{ column_name }}::variant, ARRAY_CONSTRUCT(
            {%- for value in values_list -%}
                '{{ value }}'
                {%- if not loop.last -%},{%- endif -%}
            {%- endfor -%})
    ) 
{% endmacro %}

