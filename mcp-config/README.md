# Connect your MCP client to dbt

## Claude Code, Cursor, and VS Code

### 1. Find your MCP client config

| MCP client | Config |
| --- | --- |
| Claude Code | [`remote-oauth/.mcp.json.claude-code`](remote-oauth/.mcp.json.claude-code) |
| Cursor | [`remote-oauth/.mcp.json.cursor`](remote-oauth/.mcp.json.cursor) |
| VS Code | [`remote-oauth/.mcp.json-vscode`](remote-oauth/.mcp.json-vscode) |

### 2. Copy the config

Copy the contents of your client's config and paste them into the `.mcp.json` file at the root of this repository.

### 3. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In `.mcp.json`, replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied. Save the file and sign in to dbt when prompted.

### 4. Verify the connection

Restart your MCP client and confirm that the `dbt` server is connected. Then ask:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## Codex

### 1. Configure Codex

Use the project-local TOML config at [`.codex/config.toml`](../.codex/config.toml):

```toml
[mcp_servers.dbt]
url = "https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/"
```

### 2. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL. Replace the placeholder URL in `.codex/config.toml` with the URL you copied.

### 3. Authenticate with dbt

Start the OAuth sign-in flow:

```sh
codex mcp login dbt
```

Complete the sign-in flow in your browser when it opens.

### 4. Verify the connection

Check that the server is registered:

```sh
codex
/mcp
```

Then ask Codex:

```text
What models are in my dbt project?
```
