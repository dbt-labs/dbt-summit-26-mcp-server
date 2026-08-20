select
    nullif(trim(CUSTOMER_ID), '') as customer_id,
    nullif(trim(FULL_NAME), '') as full_name,
    lower(nullif(trim(EMAIL), '')) as email,
    {% if var('DBT_BREAK_BUILD', false) %}
    nullif(trim(HOME_REGION), '') as home_region,
    {% else %}
    {{ merlinco_normalize_region('HOME_REGION') }} as home_region,
    {% endif %}
    try_to_timestamp_ntz(SIGNED_UP_AT) as signed_up_at,
    try_to_date(SIGNED_UP_AT) as signed_up_date,
    try_to_number(BIRTH_YEAR)::integer as birth_year,
    lower(nullif(trim(FAVORED_DISCIPLINE), '')) as favored_discipline
from {{ source('merlinco_apothecaries', 'RAW_CUSTOMERS') }}
