# dbt MCP server — hands-on lab (dbt Summit 2026)

Companion dbt project for the 90-minute hands-on lab **"Creating context with the dbt MCP server"** at dbt Summit 2026.

**Session page:** https://www.getdbt.com/dbt-summit/sessions/creating-context-with-dbt-mcp-server

---

## Source data

| Source system | Tables |
|---|---|
| Abracadabra POS | orders, order items, payments, potions |
| Grimoire CRM | customers, guild memberships |
| Alembic Ops | shops, ingredients, brew events, suppliers |

## Project structure

```
models/
  staging/merlinco_apothecaries/   # one model per source table, light cleaning only
  intermediate/merlinco_apothecaries/
  marts/merlinco_apothecaries/     # dims + facts, materialized as tables
```

## Getting started

[WIP]