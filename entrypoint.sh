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

exec node openclaw.mjs gateway --allow-unconfigured --port "${PORT:-3000}" --bind lan --auth password --password "$PASSWORD"
