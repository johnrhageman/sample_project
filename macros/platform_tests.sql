{% macro test_is_valid_user_origin(model, column_name) %}

with validation as (

    select
        {{ column_name }} as origin_value

    from {{ model }}

),

validation_errors as (

    select
        origin_value

    from validation
    where origin_value NOT IN (
	'signup',
	'invite:rua',
	'invite:team',
	'invite:contact',
	'unknown',
	'contact-transition',
	'invite:referral',
	'invite:compliance:admin',
	'referral',
	'review',
	'reference',
	'hire',
	'organic',
	'paid',
	'email',
	'legacy',
	'offline',
	'signup:mobile',
	'internal',
	'social',
	'referralV2',
	'org')

)

select count(*)
from validation_errors

{% endmacro %}