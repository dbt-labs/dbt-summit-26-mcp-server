{#-
  EXPERIMENT: side-by-side comparison of dbt_artifacts-based retry lookup
  vs. our run_ledger retried_from()/logical_date() chain. Renders as
  literals at compile time -- read back via manifest compiled_code, same
  technique as run_ledger_check.
-#}
{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
{% set reason = env_var('DBT_CLOUD_RUN_REASON', '') %}
{% set is_retry = reason.startswith('Retrying run ') %}
{% set prior_run_id = reason.split(' ')[-1] if is_retry else none %}
{% set artifacts_prior_run_started_at = artifacts_lookup_run_started_at(prior_run_id) if is_retry else none %}
{% set ledger_retried_from = retried_from() %}

select
    '{{ run_id }}' as run_id,
    '{{ reason }}' as run_reason,
    {% if prior_run_id %}'{{ prior_run_id }}'{% else %}null{% endif %} as prior_run_id,
    '{{ run_started_at }}' as own_run_started_at_raw,
    date '{{ logical_date() }}' as ledger_logical_date,
    {% if ledger_retried_from %}'{{ ledger_retried_from }}'{% else %}null{% endif %} as ledger_retried_from,
    {% if artifacts_prior_run_started_at %}'{{ artifacts_prior_run_started_at }}'{% else %}null{% endif %} as artifacts_prior_run_started_at
