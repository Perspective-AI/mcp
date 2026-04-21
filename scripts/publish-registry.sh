#!/usr/bin/env bash
# Publishes the current server.json to the official MCP Registry.
# Uses DNS-based authentication against getperspective.ai.
#
# Prereqs (one-time):
#   brew install mcp-publisher openssl@3
#   DNS TXT record at getperspective.ai: v=MCPv1; k=ed25519; p=<PUBLIC_KEY>
#   Private key at $KEY_PATH (ed25519, PEM, mode 600)

set -euo pipefail

KEY_PATH="${MCP_KEY_PATH:-$HOME/.config/mcp-publisher/getperspective.key.pem}"
DOMAIN="getperspective.ai"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/opt/openssl@3/bin/openssl}"

red()   { printf "\033[31m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
dim()   { printf "\033[2m%s\033[0m\n" "$1"; }

fail() { red "✗ $1"; exit 1; }

command -v mcp-publisher >/dev/null || fail "mcp-publisher not installed — run: brew install mcp-publisher"
[ -x "$OPENSSL" ] || fail "openssl@3 not found at $OPENSSL — run: brew install openssl@3"
[ -f "$KEY_PATH" ] || fail "private key not found at $KEY_PATH"
[ -f server.json ] || fail "server.json not found — run from repo root"

NAME=$(node -p "require('./server.json').name")
VERSION=$(node -p "require('./server.json').version")

green "→ Publishing $NAME v$VERSION to the MCP Registry"
dim "  domain: $DOMAIN"
dim "  key:    $KEY_PATH"
echo

# Extract Ed25519 private key as hex (never echoed).
PRIVATE_KEY=$("$OPENSSL" pkey -in "$KEY_PATH" -noout -text \
  | grep -A3 "priv:" | tail -n +2 | tr -d ' :\n')

mcp-publisher login dns --domain "$DOMAIN" --private-key "$PRIVATE_KEY"
mcp-publisher publish

echo
green "✓ Published. Verify:"
dim "  curl 'https://registry.modelcontextprotocol.io/v0.1/servers?search=$NAME'"
