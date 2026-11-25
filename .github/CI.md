# GitHub Actions configuration

The release APK job requires a repository variable named `API_BASE_URL`. Set it in **Settings → Secrets and variables → Actions → Variables** to the deployed Django API origin, for example `https://portfolio.example.com` (without `/api/v1`). The workflow rejects an empty value and any value that does not start with `https://`.

This value is a public service URL, so it belongs in a repository variable. Do not put passwords, API credentials, or private keys in repository variables; use GitHub Actions secrets for credentials if a future workflow needs them.
