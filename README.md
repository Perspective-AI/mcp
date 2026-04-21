<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Perspective-AI/mcp/main/assets/logo-dark.svg">
    <img src="https://raw.githubusercontent.com/Perspective-AI/mcp/main/assets/logo-light.svg" alt="Perspective AI" width="400">
  </picture>
</p>

# Perspective AI MCP Server

> Forms are costing you business. An AI concierge turns them into conversations.

MCP server for [Perspective AI](https://getperspective.ai). An AI Concierge replaces static forms with adaptive AI conversations that understand real situations, structure key information automatically, and trigger the right next step.

Rigid forms cause drop-off, weaken qualification, and strip away context. Perspective uses adaptive AI to capture structured data and trigger automation, so you understand what truly matters to your customers and can make decisions with conviction.

## What this MCP server does

Once connected, your AI assistant can design conversation agents, analyze conversations, deploy embeds, and automate follow-ups directly from Claude Desktop, Claude Code, Cursor, or any MCP-compatible client. Try prompts like:

```text
Design a Concierge that qualifies pricing-page leads by budget and timeline.
```
```text
Why are people abandoning my lead-capture concierge this week?
```
```text
Whenever a conversation scores above 80 on trust, push it to HubSpot and ping #sales in Slack.
```

See [Use cases](#use-cases) for the full workflow and [Available tools](#available-tools) for the tool surface.

## Quick Install

1. Download [`perspective.mcpb`](https://github.com/Perspective-AI/mcp/releases/latest/download/perspective.mcpb)
2. Double-click to open in Claude Desktop
3. Click "Install"
4. Enter your access token when prompted

## Supported clients

| Client | Install method |
|--------|----------------|
| Claude Desktop | One-click `.mcpb` bundle (above) |
| Claude Code | `claude mcp add` with HTTP transport |
| Cursor | `mcpServers` JSON config |
| Windsurf | `mcpServers` JSON config |
| Any MCP client | Remote HTTP at `https://getperspective.ai/mcp` + bearer token |

See [Manual installation](#manual-installation) for per-client setup snippets.

## Getting Your Access Token

1. Go to [Perspective AI Settings](https://getperspective.ai/settings/mcp)
2. Generate a token
3. Paste it during installation

![Generate an MCP access token](https://raw.githubusercontent.com/Perspective-AI/mcp/main/assets/generate-mcp-token.gif)

See the [full MCP documentation](https://getperspective.ai/docs/build/mcp) for troubleshooting and advanced setup.

## Available Tools

Once installed, your AI assistant can call the following tools, grouped by lifecycle stage:

**Workspaces**
- **workspace_list**: List all your workspaces
- **workspace_get**: Get workspace details
- **workspace_get_default**: Get your default workspace

**Design & iterate**
- **perspective_list**: List perspectives in a workspace
- **perspective_get**: Get perspective configuration
- **perspective_create**: Create a new perspective from a natural-language description
- **perspective_respond**: Answer a follow-up question during creation
- **perspective_update**: Refine a perspective with natural-language feedback
- **perspective_get_preview_link**: Get a preview link for testing before deployment

**Deploy & distribute**
- **perspective_get_embed_options**: Get embed snippets (fullpage, widget, popup, slider, float, card)
- **participant_invite**: Create magic-link invites, optionally sent via email

**Analyze**
- **perspective_get_stats**: Aggregate stats and distributions over a time period
- **perspective_list_conversations**: List conversations with filters (status, trust score, date)
- **perspective_get_conversation**: Get full conversation details
- **perspective_get_conversations_batch**: Batch retrieve multiple conversations

**Automate**
- **automation_manage**: Create, list, update, delete, toggle, or test automations (webhook, email, Slack, HubSpot)
- **integration_manage**: List available providers (Slack, HubSpot), connect them, and search their tools

## Use cases

Once installed, ask your AI assistant to drive the full perspective lifecycle: design, deploy, analyze, and automate.

- **Design & iterate**. Create any of four conversation agent types:
  - [**Interviewer**](https://getperspective.ai/agents/interviewer): Scales deep, qualitative interviews without losing quality
  - [**Concierge**](https://getperspective.ai/agents/concierge): Replaces static forms with delightful conversational flow
  - [**Evaluator**](https://getperspective.ai/agents/evaluator): Turns boring surveys into engaging conversations
  - [**Advocate**](https://getperspective.ai/agents/advocate): Listens first, then responds on behalf of a position, brand, or cause

  Browse [180+ templates](https://getperspective.ai/templates) or [use cases by role and industry](https://getperspective.ai/use-cases) for inspiration. Example prompts:
  - "Design a Concierge that qualifies pricing-page leads by budget and timeline. Keep the tone warm, not salesy."
  - "Build an Interviewer for churn research. Find out why customers left, what alternatives they chose, and what would have kept them."
  - "Spin up an Evaluator for 30-day onboarding feedback. What's working and what's confusing?"
  - "Set up an Advocate for our refund policy. Listen first, then explain the process without sounding defensive."
- **Deploy & distribute**. Embed on your site or send personalized invites to specific participants:
  - "Give me the popup embed snippet for my concierge and walk me through adding it to our pricing page in Next.js."
  - "Invite our 20 design partners to my beta-feedback perspective, and prefill each person's name and email."
- **Analyze**: "Why are people abandoning my lead-capture concierge this week? Pull the drop-off conversations and summarize the top reasons."
- **Automate**: "Whenever a conversation scores above 80 on trust, push it to HubSpot as a contact and ping #sales in Slack."

## Manual Installation

The Perspective MCP server is a remote HTTP endpoint at `https://getperspective.ai/mcp`. Any MCP-compatible client can connect to it.

### Claude Code

```bash
claude mcp add perspective --transport http https://getperspective.ai/mcp --header "Authorization: Bearer YOUR_TOKEN"
```

### Claude Desktop

Edit your Claude Desktop config:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

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

### Cursor

Add the same `mcpServers` config above to your Cursor settings.

### Other MCP clients

Point your client at `https://getperspective.ai/mcp` with an `Authorization: Bearer YOUR_TOKEN` header over streamable HTTP.

## Security & data

- **Token scoping**: Your MCP access token is tied to your Perspective AI account and authorizes the server to act on your behalf within your workspaces.
- **Revocation**: Generate, rotate, or revoke tokens any time at [getperspective.ai/settings/mcp](https://getperspective.ai/settings/mcp).
- **Transport**: All traffic is TLS-encrypted. Your token is sent only in the `Authorization` header to `https://getperspective.ai/mcp`.
- **Data residency**: Conversation data stays inside your Perspective AI workspace. This package is a thin stdio-to-HTTP proxy; it does not store or cache responses locally.

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
- [Full MCP Documentation](https://getperspective.ai/docs/build/mcp)
- [Brand Assets](https://getperspective.ai/assets)
- [Support](https://github.com/Perspective-AI/mcp/issues)
