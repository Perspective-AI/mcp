# Dockerfile for directory-scanner checks (e.g., Glama).
#
# This image runs server.js in catalog mode: it responds to MCP introspection
# requests (initialize, tools/list) using the static tool metadata in
# manifest.json and does not require a PERSPECTIVE_ACCESS_TOKEN.
#
# Production users of the MCP server connect directly to
# https://getperspective.ai/mcp over streamable-http with their own token;
# this image is not intended for end-user installation.

FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY server.js manifest.json ./

ENV MCP_CATALOG_MODE=1

CMD ["node", "server.js"]
