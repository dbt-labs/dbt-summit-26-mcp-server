# Connect your MCP client to dbt

## Claude Code

### 1. Add your dbt MCP URL

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In the [root `.mcp.json`](../../.mcp.json), replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied and save the file.

### 2. Verify the connection

Restart Claude Code, then run `/mcp` → Project MCPs → dbt → Authenticate to trigger browser OAuth. Then ask Claude:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## Cursor

### 1. Configure Cursor

Use the project-level config at [`.cursor/mcp.json`](../../.cursor/mcp.json):

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

with the URL you copied and save the file.

### 3. Enable and authenticate the server

1. Open the Command Palette with **Cmd+Shift+P** (macOS) or **Ctrl+Shift+P** (Windows/Linux), search for **Open Customize**, and select it.
2. Open the **MCPs** tab.
3. Find the `dbt` server associated with the `dbt-summit-26-mcp-server` project.
4. If the server is grayed out and marked **Disabled**, open it and turn on the toggle to enable it.
5. Under **Environments**, select **Authenticate**.
6. Complete the browser-based OAuth flow, then return to Cursor.

Cursor manages project MCP servers and their enabled state from the Customize page. For more information, see [Customize Cursor](https://cursor.com/docs/customize-cursor) and [Cursor's MCP documentation](https://cursor.com/docs/mcp).

### 4. Verify the connection

Return to **Customize → MCPs** and confirm that the `dbt` server is enabled and connected. Then ask in the Cursor chat window:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## VS Code

### 1. Configure VS Code

Use the workspace config at [`.vscode/mcp.json`](../../.vscode/mcp.json):

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

> [!NOTE]
> VS Code's Agent Host also reads the [root `.mcp.json`](../../.mcp.json), which this repository uses for Claude Code. Because both files define a server named `dbt`, VS Code may show the root entry as disabled or shadowed while using the VS Code-specific `.vscode/mcp.json` entry. Use the `.vscode/mcp.json` entry for the steps below. Only enable the root entry explicitly if you intend to use it instead. See [MCP configuration in the VS Code Agent Host](https://code.visualstudio.com/docs/agents/concepts/agent-host#_behavior-on-the-extension-host) for details.

### 2. Add your dbt MCP URL and start the server

In dbt platform, go to **Account settings → Access URLs → MCP Endpoint URL** and copy the URL.

In `.vscode/mcp.json`, replace:

```text
https://YOUR_DBT_HOST_URL/api/ai/v1/mcp/
```

with the URL you copied and save the file.

VS Code provides IntelliSense and inline actions for `mcp.json`. After VS Code recognizes the configuration, select **Start** above the `dbt` server entry. See [Add and manage MCP servers in VS Code](https://code.visualstudio.com/docs/agent-customization/mcp-servers#_configure-the-mcpjson-file) for details.

### 3. Authenticate with dbt

Starting the server opens a browser window for OAuth. Follow the prompts to authorize VS Code to access dbt, then return to VS Code. For more information, see the [VS Code MCP configuration reference](https://code.visualstudio.com/docs/agents/reference/mcp-configuration#_http-and-server-sent-events-sse-servers).

If the OAuth page does not open or authentication does not complete:

1. Select **Configure Trusted Domains** when VS Code prompts you.
2. Choose the first, most narrowly scoped option to trust the exact OAuth URL.
3. Return to `.vscode/mcp.json` and select **Start** or **Restart** above the `dbt` server entry.
4. Complete the browser-based OAuth flow again.

You can review or change this choice later by running **Manage Trusted Domains** from the Command Palette. See [Outgoing link protection](https://code.visualstudio.com/docs/editing/editingevolved#_outgoing-link-protection) for details.

### 4. Verify the connection

Run **MCP: List Servers** from the Command Palette and confirm that the `dbt` server is running. Then ask in the Copilot chat window:

```text
What models are in my dbt project?
```

The connection is working if the assistant returns models from your dbt project.

## Codex

### 1. Configure Codex

Use the project-local TOML config at [`.codex/config.toml`](../../.codex/config.toml):

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

Start Codex:

```sh
codex
```

Then enter to verify:

```text
/mcp
```

Once verified, ask Codex:

```text
What models are in my dbt project?
```
