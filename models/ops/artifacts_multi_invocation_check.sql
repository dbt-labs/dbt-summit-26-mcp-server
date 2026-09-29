{#-
  EXPERIMENT: proves whether dbt_artifacts' invocations table accumulates one
  row per invocation under the same dbt_cloud_run_id (no multi-invocation
  guard), compared against run_ledger's guarded single row per run_id.
  Renders as literals at compile time -- read back via manifest compiled_code,
  same technique as run_ledger_check.
-#}
{% set run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
{% set artifacts_rows_seen = artifacts_invocation_count_for_run(run_id) %}
{% set ledger_rows_seen = run_ledger_count_for_run(run_id) %}

select
    '{{ run_id }}' as run_id,
    {{ artifacts_rows_seen }} as artifacts_invocation_rows_seen_before_this_invocation,
    {{ ledger_rows_seen }} as run_ledger_rows_seen_for_this_run
