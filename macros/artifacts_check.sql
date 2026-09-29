{#-
  EXPERIMENT: can dbt_artifacts' own invocation history (which captures
  dbt_cloud_run_id / dbt_cloud_run_reason automatically) replace the
  retry-detection half of run_ledger.sql? See models/ops/artifacts_check.sql
  and ai_docs/run-started-at-idempotency.md for the write-up.
-#}

{% macro artifacts_invocations_relation() %}
  {{ return(target.database ~ '.' ~ target.schema ~ '.invocations') }}
{% endmacro %}

{% macro artifacts_lookup_run_started_at(run_id) %}
  {% if not execute or not run_id %}{{ return(none) }}{% endif %}
  {% set result = run_query(
      "select cast(run_started_at as string) as run_started_at from " ~ artifacts_invocations_relation() ~
      " where dbt_cloud_run_id = '" ~ run_id ~ "' order by run_started_at desc limit 1"
  ) %}
  {% if result.rows | length == 0 %}
    {{ return(none) }}
  {% endif %}
  {{ return(result.columns[0].values()[0]) }}
{% endmacro %}
