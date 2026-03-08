#!/bin/sh
set -e

# The setup server manages token generation, config writing, gateway lifecycle,
# and onboarding UI. See src/setup-server/server.js for details.
#
# Required env vars:
#   SETUP_PASSWORD       - HTTP Basic Auth password for /setup (mandatory)
#
# Optional env vars:
#   OPENCLAW_GATEWAY_TOKEN   - gateway auth token (auto-generated + persisted if unset)
#   OPENCLAW_PUBLIC_DOMAIN   - public hostname (sets gateway CORS allowedOrigins)
#   ENABLE_WEB_TUI           - set to "true" to enable the browser terminal at /tui
#   PORT                     - listening port (default: 3000)

# Ensure state directory exists with correct permissions and credentials subdir present.
# Fixes doctor warnings: "State directory permissions too open" and "OAuth dir missing".
STATE_DIR="${OPENCLAW_STATE_DIR:-${HOME}/.openclaw}"
mkdir -p "${STATE_DIR}/credentials"
chmod 700 "${STATE_DIR}" 2>/dev/null || true

exec node /app/src/setup-server/server.js
