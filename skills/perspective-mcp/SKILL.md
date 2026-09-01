---
name: perspective-mcp
description: Use Perspective AI MCP to design conversation agents, analyze conversations, deploy embeds, and automate follow-ups. Use when working with forms, surveys, customer interviews, lead qualification, or conversational AI.
---

# Perspective AI MCP

Use this MCP server to work with Perspective AI's conversational AI platform. Perspective replaces static forms and surveys with adaptive AI conversations.

## When to use

Use Perspective AI MCP when you need to:

- **Design conversation agents**: Create Concierge (lead qualification), Interviewer (qualitative research), Evaluator (feedback surveys), or Advocate (position representation) agents
- **Analyze conversations**: Pull conversation transcripts, trust scores, and identify drop-off patterns
- **Deploy embeds**: Get embed snippets (fullpage, widget, popup, slider, float, card) for websites
- **Automate workflows**: Create automations (webhooks, email, Slack, HubSpot) triggered by conversation events
- **Manage participants**: Send magic-link invites to specific users

## Available capabilities

Once connected via OAuth, you can:

### Design & iterate
- List and search perspectives across workspaces
- Create new perspectives from natural-language descriptions
- Refine perspectives with conversational feedback
- Get preview links for testing before deployment

### Deploy & distribute
- Get embed options with code snippets
- Send personalized participant invitations

### Analyze
- Get aggregate statistics and distributions
- List and filter conversations by status, trust score, date
- Retrieve full conversation details with transcripts
- Batch fetch conversations for bulk analysis

### Automate
- List, create, update, and delete automations
- Test automations against mock conversations
- Manage integrations (Slack, HubSpot)

## Example use cases

Ask your assistant to:

- "Design a Concierge that qualifies pricing-page leads by budget and timeline"
- "Why are people abandoning my lead-capture concierge this week?"
- "Give me the popup embed snippet for my concierge"
- "Whenever a conversation scores above 80 on trust, push it to HubSpot and ping #sales in Slack"
- "Invite our 20 design partners to my beta-feedback perspective"

## Authentication

The MCP server uses OAuth authentication. On first use, your client will open a browser window to complete the OAuth flow. Tokens are managed automatically and can be revoked at Settings → Connected Apps in your Perspective workspace.
