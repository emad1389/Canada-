# PasarGuard Panel – Railway Deploy

Deploys the PasarGuard panel from https://github.com/PasarGuard/panel.

## Deploy

1. Create a Railway project and deploy this repository as a service.
2. Railway's `PORT` is mapped to PasarGuard's `UVICORN_PORT` automatically; the app listens on `0.0.0.0`.
3. The image provides non-secret defaults for:
   - `CUSTOM_TEMPLATES_DIRECTORY=/code/templates/`
   - `SUBSCRIPTION_PAGE_TEMPLATE=subscription/index.html`
   - `ROLE=all-in-one`
4. The startup script creates the custom template directory and downloads the current official subscription template. If the download fails, an existing template is retained.
5. For persistent SQLite data, attach a Railway Volume at a suitable persistent path and configure the database URL accordingly; an external database is recommended for durable deployments.

## First owner setup

The current Pasarguard CLI supports a one-time setup key through `pasarguard cli generate-temp-key`. The key expires after five minutes and can only be used once. Generate it only when ready to complete owner setup, then use it on the dashboard setup/login page.

This key grants sensitive owner-account operations. It is deliberately not generated on every container restart or written to deployment logs. The current upstream panel does not expose supported environment variables for safely creating a fixed `admin` username/password at startup, so credentials must be established through the official owner setup flow. Do not place passwords, API keys, or temporary keys in this repository.

## Secrets

Keep secrets such as database credentials and node API keys in Railway's service Variables (or another secret manager), not in GitHub, Dockerfile, README, or image build arguments. Rotate any credential previously shared in chat before deploying.
