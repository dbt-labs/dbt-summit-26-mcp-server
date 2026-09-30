{{ config(materialized='table') }}  {#- TEMPORARY: table so the deliberate failure below actually executes (CREATE VIEW doesn't evaluate its SELECT) -#}
{#-
  EXPERIMENT: proves whether artifacts_walk_run_started_at() correctly walks
  a multi-hop retry chain (unlike the single-hop lookup from Addendum 1,
  which drifted to the immediate-prior run's own timestamp at 2 hops).
  Deliberately fails so the same node can be retried, then retried again,
  building an A -> B -> C chain to inspect. Revert after validation.
-#}
{% set own_run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
{% set own_reason = env_var('DBT_CLOUD_RUN_REASON', '') %}
{% set walk = artifacts_walk_run_started_at() %}
{% set ledger_retried_from = retried_from() %}

select
    '{{ own_run_id }}' as run_id,
    '{{ own_reason }}' as run_reason,
    {{ walk.hops }} as walk_hops,
    '{{ run_started_at }}' as own_run_started_at_raw,
    {% if walk.run_started_at %}'{{ walk.run_started_at }}'{% else %}null{% endif %} as artifacts_walk_resolved_run_started_at,
    date '{{ logical_date() }}' as ledger_logical_date,
    {% if ledger_retried_from %}'{{ ledger_retried_from }}'{% else %}null{% endif %} as ledger_retried_from,
    1 / 0 as deliberate_retry_test_failure -- TEMPORARY: forces a runtime failure to test the retry chain; revert after validation
