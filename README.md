# dbt MCP server — hands-on lab (dbt Summit 2026)

Companion dbt project for the 90-minute hands-on lab **"Creating context with the dbt MCP server"** at dbt Summit 2026.

**Session page:** https://www.getdbt.com/dbt-summit/sessions/creating-context-with-dbt-mcp-server

**Slides:** [Creating Context with the dbt MCP Server.pdf](./Creating%20Context%20with%20the%20dbt%20MCP%20Server.pdf)

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

1. Clone this repository:
   ```sh
   git clone https://github.com/dbt-labs/dbt-summit-26-mcp-server.git
   cd dbt-summit-26-mcp-server
   ```

2. For folks with — **Claude Code**, **Codex**, **Cursor**, or **VS Code** — follow the client-specific setup guide in [`mcp-config/remote-oauth/README.md`](mcp-config/remote-oauth/README.md) to connect it to the dbt MCP server. No local dbt installation or warehouse credentials are required. If you have a different agent coding harness, follow their docs for remote MCP setup.

> [!TIP]
> For this lab, you don't need to install dbt Fusion or set up a connection in `profiles.yml` as we will focus soley on using the remote dbt MCP. Installing dbt Fusion and configuring your `~/.dbt/profiles.yml` is optional if you want to run dbt locally, but we'll skip it for efficiency. See the [dbt Fusion install guide](https://docs.getdbt.com/docs/local/install-dbt?install-method=curl) if you'd like to set that up.

## Support and maintenance

This project is provided as-is for use during the dbt Summit 2026 hands-on lab.

- **No SLAs.** This is a workshop resource, not a production project.
- **Issues and PRs are not monitored.** This repo does not accept external contributions.
- **Security concerns.** See [SECURITY.md](SECURITY.md) for how to report vulnerabilities privately.