#!/usr/bin/env bash
# MCP Registry operations for ai.getperspective/mcp.
# Uses DNS-based authentication against getperspective.ai.
#
# Usage:
#   ./scripts/publish-registry.sh                                 # publish current server.json (default)
#   ./scripts/publish-registry.sh publish
#   ./scripts/publish-registry.sh delete    <version> [message]
#   ./scripts/publish-registry.sh deprecate <version> [message]
#   ./scripts/publish-registry.sh activate  <version> [message]
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
fail()  { red "✗ $1"; exit 1; }

command -v mcp-publisher >/dev/null || fail "mcp-publisher not installed — run: brew install mcp-publisher"
[ -x "$OPENSSL" ] || fail "openssl@3 not found at $OPENSSL — run: brew install openssl@3"
[ -f "$KEY_PATH" ] || fail "private key not found at $KEY_PATH"
[ -f server.json ] || fail "server.json not found — run from repo root"

NAME=$(node -p "require('./server.json').name")

login() {
  dim "  logging in via DNS as $DOMAIN"
  local PRIVATE_KEY
  PRIVATE_KEY=$("$OPENSSL" pkey -in "$KEY_PATH" -noout -text \
    | grep -A3 "priv:" | tail -n +2 | tr -d ' :\n')
  mcp-publisher login dns --domain "$DOMAIN" --private-key "$PRIVATE_KEY"
}

cmd="${1:-publish}"

case "$cmd" in
  publish)
    VERSION=$(node -p "require('./server.json').version")
    green "→ Publishing $NAME v$VERSION"
    login
    mcp-publisher publish
    echo
    green "✓ Published. Verify:"
    dim "  curl 'https://registry.modelcontextprotocol.io/v0.1/servers?search=$NAME'"
    ;;

  delete|deprecate|activate)
    VERSION="${2:-}"
    [ -n "$VERSION" ] || fail "version required: ./scripts/publish-registry.sh $cmd <version> [message]"
    MESSAGE="${3:-}"

    case "$cmd" in
      delete)    STATUS=deleted ;;
      deprecate) STATUS=deprecated ;;
      activate)  STATUS=active ;;
    esac

    green "→ Marking $NAME v$VERSION as $STATUS"
    login
    if [ -n "$MESSAGE" ]; then
      mcp-publisher status --status "$STATUS" --message "$MESSAGE" "$NAME" "$VERSION"
    else
      mcp-publisher status --status "$STATUS" "$NAME" "$VERSION"
    fi
    echo
    green "✓ Status updated to $STATUS"
    ;;

  -h|--help|help)
    sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
    ;;

  *)
    fail "unknown command: $cmd (expected: publish | delete <v> | deprecate <v> | activate <v>)"
    ;;
esac
