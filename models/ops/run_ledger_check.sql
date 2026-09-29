{% set current_retried_from = retried_from() %}

select
    '{{ env_var('DBT_CLOUD_RUN_ID', 'local') }}' as run_id,
    date '{{ logical_date() }}' as logical_date,
    {% if current_retried_from %}'{{ current_retried_from }}'{% else %}null{% endif %} as retried_from
