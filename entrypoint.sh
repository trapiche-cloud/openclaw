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

exec node /app/src/setup-server/server.js
