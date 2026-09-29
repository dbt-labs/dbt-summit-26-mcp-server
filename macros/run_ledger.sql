{% macro run_ledger_relation() %}
  {{ return(target.database ~ '.' ~ target.schema ~ '.run_ledger') }}
{% endmacro %}

{% macro create_run_ledger() %}
  create table if not exists {{ run_ledger_relation() }} (
    run_id string,
    logical_date date,
    retried_from string,
    recorded_at timestamp_ltz
  )
{% endmacro %}

{% macro default_logical_date() %}
  {{ return(
      run_started_at
        .astimezone(modules.pytz.timezone("America/Los_Angeles"))
        .strftime("%Y-%m-%d")
  ) }}
{% endmacro %}

{#-
  DBT_CLOUD_RUN_ID and DBT_CLOUD_RUN_REASON are injected automatically by
  dbt Platform on every run -- there is no var() equivalent, so env_var()
  is used here deliberately alongside this project's usual var()-based
  flag convention (see DBT_BONUS_ROUND), not as an inconsistency to fix.
-#}
{% macro record_logical_date() %}
  {% if not execute %}{{ return('') }}{% endif %}

  {% set run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
  {% set reason = env_var('DBT_CLOUD_RUN_REASON', '') %}
  {% set is_platform_run = run_id != 'local' %}

  {#- A single dbt Platform run can fire multiple invocations under the
      same run_id (e.g. separate build/test steps), each re-triggering
      on-run-start. Only the first invocation of a run should write. -#}
  {% set existing = run_query(
      "select 1 from " ~ run_ledger_relation() ~
      " where run_id = '" ~ run_id ~ "' limit 1"
  ) %}
  {% if existing.rows | length > 0 %}
    {{ return('') }}
  {% endif %}

  {% if is_platform_run and reason.startswith('Retrying run ') %}
    {% set prior_run_id = reason.split(' ')[-1] %}
    {% set prior = run_query(
        "select cast(logical_date as string) from " ~ run_ledger_relation() ~
        " where run_id = '" ~ prior_run_id ~ "' order by recorded_at desc limit 1"
    ) %}
    {% if prior.rows | length == 0 %}
      {{ exceptions.raise_compiler_error(
          "Retry of run " ~ prior_run_id ~ " but no run_ledger row exists for it. " ~
          "Refusing to guess the logical date; run a backfill with --vars logical_date instead."
      ) }}
    {% endif %}
    {% set logical_date_value = prior.columns[0].values()[0] %}
    {% set retried_from_sql = "'" ~ prior_run_id ~ "'" %}
  {% else %}
    {% set logical_date_value = var('logical_date', default_logical_date()) %}
    {% set retried_from_sql = 'null' %}
  {% endif %}

  insert into {{ run_ledger_relation() }} (run_id, logical_date, retried_from, recorded_at)
  values ('{{ run_id }}', date '{{ logical_date_value }}', {{ retried_from_sql }}, current_timestamp())
{% endmacro %}

{% macro logical_date() %}
  {% if not execute %}{{ return('1900-01-01') }}{% endif %}
  {% set run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}

  {% if run_id == 'local' %}
    {{ return(var('logical_date', default_logical_date())) }}
  {% endif %}

  {% set result = run_query(
      "select cast(logical_date as string) from " ~ run_ledger_relation() ~
      " where run_id = '" ~ run_id ~ "' order by recorded_at desc limit 1"
  ) %}
  {% if result.rows | length == 0 %}
    {{ exceptions.raise_compiler_error(
        "No run_ledger row for run " ~ run_id ~ "; on-run-start hook did not record a logical date."
    ) }}
  {% endif %}
  {{ return(result.columns[0].values()[0]) }}
{% endmacro %}

{% macro retried_from() %}
  {% if not execute %}{{ return(none) }}{% endif %}
  {% set run_id = env_var('DBT_CLOUD_RUN_ID', 'local') %}
  {% set result = run_query(
      "select retried_from from " ~ run_ledger_relation() ~
      " where run_id = '" ~ run_id ~ "' order by recorded_at desc limit 1"
  ) %}
  {% if result.rows | length == 0 %}
    {{ return(none) }}
  {% endif %}
  {{ return(result.columns[0].values()[0]) }}
{% endmacro %}
