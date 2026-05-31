# How to update brandom.agency

This folder is the website **brandom.agency**. To make any change to the site, just ask Claude in natural language. You don't need to know any code.

## What you can ask Claude

Examples — say things like this:

- "Change the headline to 'Hi, I'm Violet — your AI brand partner.'"
- "Swap the background video for a new one I just dropped in this folder."
- "Replace the logo in the top right with logos/newlogo.png."
- "Update the email address from violet@brandom.io to hello@brandom.agency."
- "Make the page background pure black instead of dark grey."

Then say:

> **Push it live.**

Claude will commit and push the change to GitHub. The site updates automatically within about 30 seconds. You can refresh https://brandom.agency to see it.

---

## Instructions for Claude (read this first)

This is a static site deployed automatically via GitHub Actions.

**Project**

- Working folder: `~/Desktop/brandom.agency`
- GitHub repo: `https://github.com/AnuragMittal-arch/Brandom-Agency` (branch `main`)
- Live URL: `https://brandom.agency`
- Hosting: DigitalOcean droplet `192.241.189.81` with aaPanel, docroot `/www/wwwroot/brandom.agency`

**Key files**

- `index.html` — main page markup
- `styles.css` — styling
- `Violetweb_compressed.mp4`, `violet-web.mp4` — background videos
- `logos/` — brand logos
- `.user.ini` — server-managed, do not touch
- `.github/workflows/deploy.yml` — CI/CD pipeline, do not edit unless asked
- `fix-git-once.command` — one-time local setup helper for the user

**Deployment**

A push to `main` triggers `.github/workflows/deploy.yml`, which rsyncs the repo to the droplet's docroot and fixes ownership. Required GitHub secrets are already configured: `SSH_HOST`, `SSH_USER`, `SSH_PORT`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH`.

**When the user asks for a change**

1. Make the edit in the user's folder (`~/Desktop/brandom.agency`).
2. Confirm the change in plain English ("Updated the headline to X").
3. When the user says "push it live" / "deploy" / "make it live":
   - Run `git add . && git commit -m "<short description>" && git push origin main`
   - The push triggers the workflow automatically.
4. Tell the user the site will update in about 30 seconds and to refresh the page.

**If `git push` fails because of authentication**

Tell the user to open Terminal and run, just once:

```bash
cd ~/Desktop/brandom.agency
git config credential.helper osxkeychain
git push
# enter GitHub username and a Personal Access Token when prompted
# (token comes from https://github.com/settings/tokens — scopes: repo, workflow)
```

After that, credentials are cached in Keychain and future pushes from Claude will succeed silently.

**If `.git` is missing or broken**

The user has a script `fix-git-once.command` in this folder. Tell them to double-click it in Finder — it will clean up and re-clone from GitHub.

**Do not**

- Edit `.user.ini`
- Edit GitHub Actions secrets
- Force-push or rewrite history on `main`
- Add binary files larger than 90 MB (GitHub's hard cap is 100 MB; use Git LFS or external hosting instead)

**Verifying a deploy**

After pushing, the latest run is visible at `https://github.com/AnuragMittal-arch/Brandom-Agency/actions`. A green checkmark means the site is updated.
