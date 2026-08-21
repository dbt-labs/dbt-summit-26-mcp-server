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

1. Clone this repository:
   ```sh
   git clone https://github.com/dbt-labs/dbt-summit-26-mcp-server.git
   cd dbt-summit-26-mcp-server
   ```

2. [Install dbt Fusion](https://docs.getdbt.com/docs/local/install-dbt?install-method=curl).

3. Set up your profile. Copy the example and fill in your Snowflake credentials:
   ```sh
   cp profiles.yml.example ~/.dbt/profiles.yml
   ```

4. Verify your setup:
   ```sh
   dbt parse
   ```

5. Configure the dbt MCP server in your AI assistant. Update `.mcp.json` with your dbt platform account URL:
   ```json
   {
     "mcpServers": {
       "dbt": {
         "type": "http",
         "url": "https://{your-account-prefix}.{region}.dbt.com/api/ai/v1/mcp"
       }
     }
   }
   ```
   Your account URL can be found in dbt platform under **Account settings**.

## Support and maintenance

This project is provided as-is for use during the dbt Summit 2026 hands-on lab.

- **No SLAs.** This is a workshop resource, not a production project.
- **Issues and PRs are not monitored.** This repo does not accept external contributions.
- **Security concerns.** See [SECURITY.md](SECURITY.md) for how to report vulnerabilities privately.