#!/usr/bin/env node

/**
 * Perspective AI MCP Extension
 *
 * Proxies Claude Desktop's stdio transport to the Perspective AI remote MCP server.
 */

const { spawn } = require("child_process");

const ACCESS_TOKEN = process.env.PERSPECTIVE_ACCESS_TOKEN;
const SERVER_URL =
  process.env.PERSPECTIVE_SERVER_URL || "https://getperspective.ai/mcp";

if (!ACCESS_TOKEN) {
  console.error("Error: PERSPECTIVE_ACCESS_TOKEN is required");
  process.exit(1);
}

const child = spawn(
  "npx",
  [
    "-y",
    "mcp-remote",
    SERVER_URL,
    "--header",
    `Authorization: Bearer ${ACCESS_TOKEN}`,
  ],
  {
    stdio: "inherit",
    shell: true,
  }
);

child.on("error", (err) => {
  console.error("Failed to start mcp-remote:", err.message);
  process.exit(1);
});

child.on("exit", (code) => {
  process.exit(code || 0);
});

process.on("SIGINT", () => child.kill("SIGINT"));
process.on("SIGTERM", () => child.kill("SIGTERM"));
