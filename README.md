# brandom.agency

Static site for brandom.agency. Deployed to a DigitalOcean droplet running aaPanel at `/www/wwwroot/brandom.agency/`.

## Local development

It's plain HTML/CSS — open `index.html` in a browser, or serve with any static server:

```bash
python3 -m http.server 8000
```

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which rsyncs the repo to the aaPanel web root over SSH.

Required GitHub repository secrets:

| Secret | Value |
| --- | --- |
| `SSH_HOST` | Droplet IP or hostname |
| `SSH_USER` | SSH user (e.g. `root` or `www`) |
| `SSH_PORT` | SSH port (usually `22`) |
| `SSH_PRIVATE_KEY` | Private key whose public key is in the droplet's `~/.ssh/authorized_keys` |
| `DEPLOY_PATH` | Web root path, e.g. `/www/wwwroot/brandom.agency` |

See `DEPLOY_SETUP.md` for the full one-time setup walkthrough.
