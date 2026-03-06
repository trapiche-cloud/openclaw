#!/bin/sh
set -e

# Generate a random gateway token if not provided via env.
# Print it to logs so the user can retrieve it from the Trapiche logs UI.
TOKEN="${OPENCLAW_GATEWAY_TOKEN:-$(node -e "process.stdout.write(require('crypto').randomBytes(32).toString('hex'))")}"

echo ""
echo "========================================"
echo "  OPENCLAW_GATEWAY_TOKEN=$TOKEN"
echo "========================================"
echo ""

exec node openclaw.mjs gateway --allow-unconfigured --port "${PORT:-3000}" --bind lan --token "$TOKEN"
