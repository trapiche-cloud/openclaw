#!/bin/sh
set -e

# Generate a random token if not provided via env.
# Print it to logs so the user can retrieve it from the Trapiche logs UI.
# Token auth is persisted in the Control UI browser session (paste once, never again).
TOKEN="${OPENCLAW_GATEWAY_TOKEN:-$(node -e "process.stdout.write(require('crypto').randomBytes(32).toString('hex'))")}"

echo ""
echo "========================================"
echo "  OPENCLAW_GATEWAY_TOKEN=$TOKEN"
echo "========================================"
echo ""

# Write the gateway config so it is loaded natively by OpenClaw.
mkdir -p /home/node/.openclaw
TOKEN="$TOKEN" node -e "
const fs = require('fs');
const cfg = {
  gateway: {
    auth: { mode: 'token', token: process.env.TOKEN },
    controlUi: { dangerouslyAllowHostHeaderOriginFallback: true }
  }
};
fs.writeFileSync('/home/node/.openclaw/openclaw.json', JSON.stringify(cfg, null, 2));
"

PORT="${PORT:-3000}"

# Auto-approve device pairing in the background.
# Users already proved identity via the gateway token — pairing is redundant friction.
# Polls until the gateway is ready, then approves any pending request once.
(
  until node openclaw.mjs devices list --url "ws://127.0.0.1:$PORT" --token "$TOKEN" >/dev/null 2>&1; do
    sleep 2
  done
  while true; do
    node openclaw.mjs devices approve --latest --url "ws://127.0.0.1:$PORT" --token "$TOKEN" 2>/dev/null || true
    sleep 3
  done
) &

exec node openclaw.mjs gateway --allow-unconfigured --port "$PORT" --bind lan
