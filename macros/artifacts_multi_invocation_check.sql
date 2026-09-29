{#-
  EXPERIMENT: does dbt_artifacts' invocations table guard against multiple
  invocations firing under the same dbt_cloud_run_id (e.g. a multi-step job),
  the way run_ledger.record_logical_date()'s existing-row check does? See
  models/ops/artifacts_multi_invocation_check.sql and
  ai_docs/run-started-at-idempotency.md for the write-up.
-#}

{% macro artifacts_invocations_relation() %}
  {{ return(target.database ~ '.' ~ target.schema ~ '.invocations') }}
{% endmacro %}

{% macro artifacts_invocation_count_for_run(run_id) %}
  {% if not execute or not run_id %}{{ return(0) }}{% endif %}
  {% set result = run_query(
      "select count(*) as cnt from " ~ artifacts_invocations_relation() ~
      " where dbt_cloud_run_id = '" ~ run_id ~ "'"
  ) %}
  {{ return(result.columns[0].values()[0]) }}
{% endmacro %}

{% macro run_ledger_count_for_run(run_id) %}
  {% if not execute or not run_id %}{{ return(0) }}{% endif %}
  {% set result = run_query(
      "select count(*) as cnt from " ~ run_ledger_relation() ~
      " where run_id = '" ~ run_id ~ "'"
  ) %}
  {{ return(result.columns[0].values()[0]) }}
{% endmacro %}
