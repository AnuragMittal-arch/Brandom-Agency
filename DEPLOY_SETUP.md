# One-time deploy setup

You run these steps once. After that, every `git push` to `main` deploys automatically.

## 1. Create the GitHub repo

1. Go to https://github.com/new
2. Repo name: `brandom.agency` (or anything you like)
3. **Do not** initialize with README/.gitignore — the local repo already has them
4. Create

GitHub will show a "push an existing repository" snippet. Use it after step 2 below.

## 2. Initialize the repo and push

In Terminal on your Mac:

```bash
cd ~/Desktop/brandom.agency
rm -rf .git                       # clean any partial state
git init -b main
git add .
git commit -m "Initial commit: brandom.agency static site + CI/CD"
git remote add origin git@github.com:<your-username>/brandom.agency.git
git push -u origin main
```

(Use the HTTPS URL — `https://github.com/<your-username>/brandom.agency.git` — instead if you don't have SSH set up for GitHub.)

## 3. Create an SSH deploy key

On your **local Mac**, generate a dedicated keypair for the GitHub Action — do not reuse your personal key.

```bash
ssh-keygen -t ed25519 -C "github-actions-deploy" -f ~/.ssh/brandom_deploy -N ""
```

This creates two files:
- `~/.ssh/brandom_deploy`     — private key (goes into GitHub secrets)
- `~/.ssh/brandom_deploy.pub` — public key (goes onto the droplet)

## 4. Authorize the key on the droplet

SSH into your DigitalOcean droplet as the user the Action will use (usually `root` for aaPanel) and append the public key:

```bash
# from your Mac
ssh root@<droplet-ip>

# on the droplet
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "<paste contents of ~/.ssh/brandom_deploy.pub here>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Quick test from your Mac:

```bash
ssh -i ~/.ssh/brandom_deploy root@<droplet-ip> "echo ok"
```

You should see `ok` with no password prompt.

## 5. Add GitHub repository secrets

Go to your repo on GitHub → **Settings → Secrets and variables → Actions → New repository secret**. Add each of these:

| Name | Example value |
| --- | --- |
| `SSH_HOST` | `203.0.113.42` (your droplet IP) |
| `SSH_USER` | `root` |
| `SSH_PORT` | `22` |
| `SSH_PRIVATE_KEY` | Paste the full contents of `~/.ssh/brandom_deploy` (including the `-----BEGIN` / `-----END` lines) |
| `DEPLOY_PATH` | `/www/wwwroot/brandom.agency` |

To copy the private key on your Mac:

```bash
pbcopy < ~/.ssh/brandom_deploy
```

## 6. Trigger the first deploy

Either push any change, or run the workflow manually:

GitHub repo → **Actions** tab → **Deploy to DigitalOcean (aaPanel)** → **Run workflow**.

Watch the run. The first run uploads everything; subsequent runs only sync changes (rsync delta).

## 7. Verify

Open `https://brandom.agency` in a browser. You should see the latest version of the site.

## Notes & gotchas

- **`.user.ini` is intentionally not deployed.** It's an aaPanel/PHP per-directory config that already exists on the server and is excluded by `.gitignore` and the workflow's rsync excludes. Leave it alone on the droplet.
- **`--delete` is on.** Files removed from git are removed from the server on the next deploy. If you want to keep server-side files (e.g. uploads), add them to the `--exclude` list in `.github/workflows/deploy.yml`.
- **Large video files** (`Violetweb_compressed.mp4` ~15 MB, `violet-web.mp4` ~4 MB) are committed directly. GitHub's hard limit is 100 MB per file, so this is fine. If you add more big media, switch to Git LFS.
- **Ownership/permissions:** the workflow runs `chown -R www:www` so aaPanel's nginx/Apache user can serve files. If your droplet uses a different web user, edit that line in the workflow.
- **Firewall:** make sure port 22 (or whatever `SSH_PORT` is) is open in the DigitalOcean firewall and in aaPanel's security panel for GitHub Actions' IP ranges. The simplest is to allow port 22 from anywhere; or restrict to GitHub's published IP list (https://api.github.com/meta).
