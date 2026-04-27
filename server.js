#!/usr/bin/env node

/**
 * Perspective AI MCP Extension
 *
 * - Proxy mode (default): forwards stdio to the remote MCP endpoint when
 *   PERSPECTIVE_ACCESS_TOKEN is set.
 * - Catalog mode (MCP_CATALOG_MODE=1): serves the static tool list from
 *   manifest.json without any network calls. Used by directory checks
 *   (e.g., Glama) that introspect servers without an access token.
 */

const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");

const ACCESS_TOKEN = process.env.PERSPECTIVE_ACCESS_TOKEN;
const SERVER_URL = process.env.PERSPECTIVE_SERVER_URL || "https://getperspective.ai/mcp";
const CATALOG_MODE = process.env.MCP_CATALOG_MODE === "1";

if (CATALOG_MODE) {
  runCatalog().catch(() => process.exit(1));
} else if (!ACCESS_TOKEN) {
  console.error("PERSPECTIVE_ACCESS_TOKEN is required");
  process.exit(1);
} else {
  runProxy().catch(() => process.exit(1));
}

async function runCatalog() {
  const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
  const {
    ListToolsRequestSchema,
    CallToolRequestSchema,
  } = require("@modelcontextprotocol/sdk/types.js");
  const manifest = require("./manifest.json");

  const server = new Server(
    { name: manifest.name, version: manifest.version },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: (manifest.tools || []).map((t) => ({
      name: t.name,
      description: t.description,
      inputSchema: { type: "object" },
    })),
  }));

  server.setRequestHandler(CallToolRequestSchema, async () => ({
    content: [
      {
        type: "text",
        text: "Tool calls require an access token. Configure PERSPECTIVE_ACCESS_TOKEN or connect via https://getperspective.ai/mcp.",
      },
    ],
    isError: true,
  }));

  await server.connect(new StdioServerTransport());
}

async function runProxy() {
  const { StreamableHTTPClientTransport } = require("@modelcontextprotocol/sdk/client/streamableHttp.js");

  const localTransport = new StdioServerTransport();
  let remoteTransport = null;

  localTransport.onmessage = async (message) => {
    if (!remoteTransport) {
      remoteTransport = new StreamableHTTPClientTransport(new URL(SERVER_URL), {
        requestInit: { headers: { Authorization: `Bearer ${ACCESS_TOKEN}` } },
      });

      remoteTransport.onmessage = (response) => localTransport.send(response);
      remoteTransport.onclose = () => process.exit(0);

      await remoteTransport.start();
    }

    await remoteTransport.send(message);
  };

  localTransport.onclose = () => {
    remoteTransport?.close();
    process.exit(0);
  };

  await localTransport.start();
}
