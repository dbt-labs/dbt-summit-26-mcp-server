{#-
  EXPERIMENT: full multi-hop retry-chain walk against dbt_artifacts.invocations.
  At each hop, looks up the EARLIEST invocation row (min run_started_at) for a
  given run_id -- folding in the multi-invocation-guard fix from the prior
  experiment -- then checks that row's own dbt_cloud_run_reason: if it's
  itself a retry, jumps back to the referenced run_id and repeats; otherwise
  that row's run_started_at is the answer. Bounded by max_hops to guard
  against cycles / malformed DBT_CLOUD_RUN_REASON values.
  See models/ops/artifacts_multihop_check.sql and
  ai_docs/run-started-at-idempotency.md for the write-up.
-#}

{% macro artifacts_invocations_relation() %}
  {{ return(target.database ~ '.' ~ target.schema ~ '.invocations') }}
{% endmacro %}

{% macro artifacts_earliest_invocation_row(run_id) %}
  {% if not execute or not run_id %}{{ return(none) }}{% endif %}
  {% set result = run_query(
      "select cast(run_started_at as string) as run_started_at, dbt_cloud_run_reason as run_reason from " ~ artifacts_invocations_relation() ~
      " where dbt_cloud_run_id = '" ~ run_id ~ "' order by run_started_at asc limit 1"
  ) %}
  {% if result.rows | length == 0 %}
    {{ return(none) }}
  {% endif %}
  {{ return({'run_started_at': result.columns[0].values()[0], 'run_reason': result.columns[1].values()[0]}) }}
{% endmacro %}

{% macro artifacts_walk_run_started_at(max_hops=25) %}
  {% if not execute %}{{ return({'run_started_at': none, 'hops': 0, 'terminal_run_id': none}) }}{% endif %}
  {% set own_run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
  {% set own_reason = env_var('DBT_CLOUD_RUN_REASON', '') %}

  {% if own_run_id == 'local' or not own_reason.startswith('Retrying run ') %}
    {{ return({'run_started_at': none, 'hops': 0, 'terminal_run_id': own_run_id}) }}
  {% endif %}

  {% set ns = namespace(lookup_run_id=own_reason.split(' ')[-1], resolved_ts=none, hops=0) %}

  {% for i in range(max_hops) %}
    {% if not ns.resolved_ts %}
      {% set ns.hops = ns.hops + 1 %}
      {% set row = artifacts_earliest_invocation_row(ns.lookup_run_id) %}
      {% if not row %}
        {{ exceptions.raise_compiler_error(
            "artifacts_walk_run_started_at: no dbt_artifacts invocation row found for run_id " ~
            ns.lookup_run_id ~ " (hop " ~ ns.hops ~ "). Chain is broken."
        ) }}
      {% endif %}
      {% if row.run_reason and row.run_reason.startswith('Retrying run ') %}
        {% set ns.lookup_run_id = row.run_reason.split(' ')[-1] %}
      {% else %}
        {% set ns.resolved_ts = row.run_started_at %}
      {% endif %}
    {% endif %}
  {% endfor %}

  {% if not ns.resolved_ts %}
    {{ exceptions.raise_compiler_error(
        "artifacts_walk_run_started_at: exceeded " ~ max_hops ~
        " hops without resolving to a non-retry run; possible cycle."
    ) }}
  {% endif %}

  {{ return({'run_started_at': ns.resolved_ts, 'hops': ns.hops, 'terminal_run_id': ns.lookup_run_id}) }}
{% endmacro %}
