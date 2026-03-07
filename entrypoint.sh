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

exec node openclaw.mjs gateway --allow-unconfigured --port "${PORT:-3000}" --bind lan
