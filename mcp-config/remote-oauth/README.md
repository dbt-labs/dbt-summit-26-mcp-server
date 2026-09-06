# Connect your MCP client to dbt

## Claude Code

### 1. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In `.mcp.json` at the root of this repository, replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied.

### 2. Verify the connection

Restart Claude Code, then run `/mcp` → Project MCPs → dbt → Authenticate to trigger browser OAuth. Then ask:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## Cursor

### 1. Configure Cursor

Use the project-level config at [`.cursor/mcp.json`](../.cursor/mcp.json):

```json
{
  "mcpServers": {
    "dbt": {
      "url": "https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/"
    }
  }
}
```

### 2. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In `.cursor/mcp.json`, replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied.

### 3. Verify the connection

Restart Cursor, open **Cursor Settings → MCP**, and confirm that the `dbt` server is connected. Complete the browser OAuth flow when prompted. Then ask:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## VS Code

### 1. Configure VS Code

Use the workspace config at [`.vscode/mcp.json`](../.vscode/mcp.json):

```json
{
  "servers": {
    "dbt": {
      "type": "http",
      "url": "https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/"
    }
  }
}
```

### 2. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In `.vscode/mcp.json`, replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied.

### 3. Verify the connection

Restart VS Code, run **MCP: List Servers** from the Command Palette, and confirm that the `dbt` server is connected. Complete the browser OAuth flow when prompted. Then ask:

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
