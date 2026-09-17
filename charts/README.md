# dbt charts — setup notes

Notes from building the `orders-revenue.yml` board: what was done, how dbt charts works, and the commands used.

## What we did

1. **Installed dbt charts** — `uv tool install dbt-charts` (already installed), then ran `dct skills intro` to load the onboarding skill.
2. **Clarified scope** — "make charts of this" was ambiguous (no dataset named), so we picked a subject: **orders & revenue**.
3. **Scaffolded a charts project** in this repo — `dct init --yes` created `dbt_charts.yml`, `charts/`, and installed the workflow skills into `.claude/skills/` and `.agents/skills/`.
4. **Fixed the warehouse connection** — the project's dbt profile (`merlin-co`, Snowflake) had no adapter installed in dbt charts' own environment. Reinstalled with the adapter bundled: `uv tool install dbt-charts --with dbt-snowflake --force`, then registered a `sources:` entry in `dbt_charts.yml` pointing at that dbt profile.
5. **Explored the real schema** with `dct query` against `fct_orders`, `dim_shops`, etc. — confirmed column names, `order_status`/`order_channel` values, date range (Jul 2024–Jun 2026), and shop/region cardinality before writing any chart YAML.
6. **Built the board incrementally** in `charts/orders-revenue.yml`: KPI row → monthly trend → channel/status breakdown → top shops/region breakdown, validating and rendering after every addition.
7. **Ran the review skills** — structural review caught missing `notes:` on charts (fixed), then visual review (rendered PNG, inspected it) came back clean.
8. **Delivered** the rendered board plus a written read (what the numbers show, follow-ups worth taking).

## How dbt charts works

- **`dct`** is the CLI (installed as a `uv tool`). It reads a **project** — a `dbt_charts.yml` at the root plus a `charts/` directory of board files.
- **`dbt_charts.yml`** is config only: it declares named **`sources:`** (warehouse/file connections). A source can be `type: dbt_profile` (reuses an existing dbt project's `profiles.yml` — what we used), or a direct `postgres`/`snowflake`/`bigquery`/`duckdb`/`csv`/etc. connection.
- **A board** (`charts/*.yml`) is one YAML file with three parts:
  - `queries:` — named SQL (or inline data) pulling from a source
  - `charts:` — named visualizations, each pointing at a query, with a `type` (`kpi`, `line`, `bar`, `area`, `scatter`, `pie`, `heatmap`, `table`) and field encodings (`x`, `y`, `color`, etc.)
  - `rows:`/`cols:` — the layout, referencing chart names
- **`{{ variable }}`** syntax lets a query be parameterized (e.g. `order_status`), exposed as a filter on the rendered board.
- Nothing renders with a plotting library or notebook — `dct` compiles the YAML to Vega-Lite and rasterizes it, so SVG/PNG/HTML/terminal output all come from the same spec.
- **dbtcharts.com (Cloud)** can host the same board files against a live warehouse for sharing — separate from local rendering, and only for warehouse-backed sources (not local DuckDB files).

## Skills used (from `dct skills`)

| Skill | What it did here |
|---|---|
| `dct-intro` | First orientation — explained the tool and pointed to the right next skill |
| `dct-analyst-runbook` | Framed the request (pick response shape → dashboard), and the delivery format (read + follow-ups) |
| `dct-data-exploration` (implicitly, via `dct query`) | Verified real column names/values before writing SQL |
| `dct-board-build` | The actual build loop — one chart at a time, validate → render after each |
| `dct-board-review` (orchestrator) → `dct-board-structural-review` + `dct-board-visual-review` | Pre-delivery check: YAML checklist (caught missing chart `notes:`), then rendered-PNG visual check (no issues) |

## Commands used

```bash
# Setup
uv tool install dbt-charts                                  # install the CLI
uv tool install dbt-charts --with dbt-snowflake --force     # inject the warehouse adapter
dct skills intro                                             # read the onboarding skill
dct init --yes                                                # scaffold dbt_charts.yml + charts/

# Skills
dct skills <name>                                             # print a workflow skill in full
dct skills                                                    # list all packaged skills

# Data exploration
dct query <source> "<sql>"                                    # ad-hoc SQL against a registered source
dct search "<keywords>"                                        # find existing boards that already answer this

# Docs
dct docs                                                       # YAML reference overview
dct docs <topic>                                               # one section (e.g. `dct docs sources`)
dct docs -s "<query>"                                           # full-text search the reference

# Build loop
dct validate charts/orders-revenue.yml                        # schema + cross-reference check, no rendering
dct render charts/orders-revenue.yml                          # compile + render (svg by default)
dct render charts/orders-revenue.yml --format png             # render to PNG (for visual review)
dct query charts/orders-revenue.yml <query_name>               # run one named query from a saved board

# Serve
dct serve                                                      # live preview server, re-renders on save
```

## Files changed/added

- `dbt_charts.yml` — project config; added the `sources.analytics` entry (`type: dbt_profile`, `profile: merlin-co`)
- `charts/orders-revenue.yml` — the board itself (8 charts: 3 KPIs, 1 trend line, 4 breakdown bars)
- `charts/guide.yml`, `charts/meta.yml` — starter files from `dct init`
- `.claude/skills/dct-*`, `.agents/skills/dct-*` — the workflow skills, installed locally so future turns find them without re-reading `dct skills intro`
- MCP wiring added to `.cursor/mcp.json`, `.codex/config.toml`, `.vscode/mcp.json`, `.github/copilot/mcp.json` (so editors/agents can call dbt charts as MCP tools instead of shelling out to `dct`)

None of this is committed yet — it's all sitting as untracked/modified files in the working tree.
