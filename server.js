#!/usr/bin/env node

/**
 * Perspective AI MCP Extension
 * Proxies Claude Desktop (stdio) to Perspective AI remote MCP server (HTTP).
 */

const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");
const { StreamableHTTPClientTransport } = require("@modelcontextprotocol/sdk/client/streamableHttp.js");

const ACCESS_TOKEN = process.env.PERSPECTIVE_ACCESS_TOKEN;
const SERVER_URL = process.env.PERSPECTIVE_SERVER_URL || "https://getperspective.ai/mcp";

if (!ACCESS_TOKEN) {
  console.error("PERSPECTIVE_ACCESS_TOKEN is required");
  process.exit(1);
}

async function runProxy() {
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

runProxy().catch(() => process.exit(1));
