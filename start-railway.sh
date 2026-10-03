#!/usr/bin/env bash
set -e

# Railway provides a dynamic port; PasarGuard reads UVICORN_PORT.
export UVICORN_HOST="${UVICORN_HOST:-0.0.0.0}"
export UVICORN_PORT="${PORT:-8000}"

# SQLite is a fallback only; use a persistent volume or external database for durable data.
export SQLALCHEMY_DATABASE_URL="${SQLALCHEMY_DATABASE_URL:-sqlite+aiosqlite:///db.sqlite3}"
export ROLE="${ROLE:-all-in-one}"

# Trust Railway's reverse proxy headers for HTTPS detection.
export UVICORN_PROXY_HEADERS="${UVICORN_PROXY_HEADERS:-true}"
export UVICORN_FORWARDED_ALLOW_IPS="${UVICORN_FORWARDED_ALLOW_IPS:-*}"

# Custom subscription template settings are non-secret defaults in the Docker image.
export CUSTOM_TEMPLATES_DIRECTORY="${CUSTOM_TEMPLATES_DIRECTORY:-/code/templates/}"
export SUBSCRIPTION_PAGE_TEMPLATE="${SUBSCRIPTION_PAGE_TEMPLATE:-subscription/index.html}"
TEMPLATE_DIR="${CUSTOM_TEMPLATES_DIRECTORY%/}/subscription"
mkdir -p "$TEMPLATE_DIR"

# Refresh the official subscription template at startup; keep any existing file if unavailable.
echo "Updating PasarGuard subscription template..."
if curl -fL "https://github.com/PasarGuard/subscription-template/releases/latest/download/index.html" -o "$TEMPLATE_DIR/index.html"; then
  echo "Subscription template updated successfully."
else
  echo "WARNING: Could not update subscription template; using the existing template if present."
fi

echo "Starting PasarGuard panel on port ${UVICORN_PORT}..."
exec /code/start.sh
