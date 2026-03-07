#!/bin/sh
set -e

# Generate a random password if not provided via env.
# Print it to logs so the user can retrieve it from the Trapiche logs UI.
PASSWORD="${OPENCLAW_GATEWAY_PASSWORD:-$(node -e "process.stdout.write(require('crypto').randomBytes(16).toString('hex'))")}"

echo ""
echo "========================================"
echo "  OPENCLAW_GATEWAY_PASSWORD=$PASSWORD"
echo "========================================"
echo ""

# Write the gateway config with the password so it is loaded natively by OpenClaw.
mkdir -p /home/node/.openclaw
node -e "
const fs = require('fs');
const cfg = {
  gateway: {
    auth: { mode: 'password', password: process.env.PASSWORD },
    controlUi: { dangerouslyAllowHostHeaderOriginFallback: true }
  }
};
fs.writeFileSync('/home/node/.openclaw/openclaw.json', JSON.stringify(cfg, null, 2));
" PASSWORD="$PASSWORD"

exec node openclaw.mjs gateway --allow-unconfigured --port "${PORT:-3000}" --bind lan
