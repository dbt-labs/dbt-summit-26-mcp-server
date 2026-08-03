# dbt MCP server — hands-on lab (dbt Summit 2026)

Companion dbt project for the 90-minute hands-on lab **"Creating context with the dbt MCP server"** at dbt Summit 2026.

**Session page:** https://www.getdbt.com/dbt-summit/sessions/creating-context-with-dbt-mcp-server

---

## What this repo is

This project gives you a realistic dbt codebase to work against while learning how to connect an AI client to dbt using the dbt MCP server. The lab covers:

- What MCP is and how it differs from chat-only AI workflows
- Configuring a remote dbt MCP server connection and verifying it works
- Using MCP-enabled context to complete dbt workflows that chat-only AI can't reliably do — exploring lineage, querying the Semantic Layer, tracing blast radius, and drafting incident messages from real job run data

## The scenario

You've just joined the data team at **Merlin & Co. Apothecaries**, a fictional potion shop network. On your first morning, finance sends an urgent message: the regional revenue dashboard is broken. You work through diagnosis, an interim workaround, and an incident summary — all using your MCP-connected AI.

## Source data

Raw source tables are based on the [merlinco-apothecaries](https://github.com/dbt-labs/merlinco-apothecaries) dataset. Three fictional source systems feed the project:

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