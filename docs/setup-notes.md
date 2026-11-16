# Workshop Environment Setup

Notes for running the dbt Summit MCP server demo locally.

## Prerequisites

- Python 3.11+
- dbt 1.9 or newer
- A Snowflake trial account with the sample data loaded

## Local run

1. Copy `mcp-config/` into your project.
2. Point `DBT_PROFILES_DIR` at the folder that contains your `profiles.yml`.
3. Start the server with `python -m mcp_server`.

## Troubleshooting

If the server cannot find the manifest, run `dbt parse` once and confirm that
`target/manifest.json` has been written.
