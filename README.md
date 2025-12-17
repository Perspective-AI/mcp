# Perspective AI MCP Extension

One-click installation for Claude Desktop to connect with Perspective AI.

## Quick Install

1. Download [`perspective.mcpb`](https://github.com/Perspective-AI/perspective-mcp/releases/latest/download/perspective.mcpb)
2. Double-click to open in Claude Desktop
3. Click "Install"
4. Enter your access token when prompted

## Getting Your Access Token

1. Go to [Perspective AI Settings](https://getperspective.ai/settings/mcp)
2. Generate a token
3. Paste it during installation

## Available Tools

Once installed, Claude can:

- **workspace_list** - List all your workspaces
- **workspace_get** - Get workspace details
- **perspective_list** - List perspectives in a workspace
- **perspective_get** - Get perspective configuration
- **perspective_create** - Create new perspectives
- **perspective_update** - Update perspectives with feedback
- **perspective_get_stats** - Get aggregate statistics
- **perspective_list_conversations** - List conversations with filters
- **perspective_get_conversation** - Get full conversation details
- **perspective_get_conversations_batch** - Batch retrieve conversations
- **perspective_get_preview_link** - Get shareable preview links
- **perspective_get_embed_options** - Get embed configuration

## Manual Installation

If you prefer manual setup:

```json
{
  "mcpServers": {
    "perspective": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://getperspective.ai/mcp",
        "--header",
        "Authorization: Bearer YOUR_TOKEN"
      ]
    }
  }
}
```

Add this to:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

## Building from Source

```bash
npm install
npm run pack
```

Outputs `perspective.mcpb` in the current directory.

## Releasing

```bash
npm run release
```

Bumps version, commits, tags, and pushes. GitHub Action creates the release.

## Links

- [Get Access Token](https://getperspective.ai/settings/mcp)
- [Support](https://github.com/Perspective-AI/perspective-mcp/issues)
