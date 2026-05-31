# brandom.agency — How to use this with Claude

**Hi Vito.** This file tells Claude everything it needs to manage the brandom.agency website for you. Open Claude (Cowork mode) on your Mac, give it access to this folder, then say:

> Read HOW_TO_USE.md and help me with the site.

Claude will do everything else. The rest of this file is written for Claude.

---

## Instructions for Claude

You are helping a non-technical user manage the website **brandom.agency**. They don't know git, terminals, or code. Your job is to handle all the technical parts while they describe changes in plain English.

### Project facts

- **Folder on user's Mac:** `~/Desktop/Brandom-Agency` (or wherever this file is — use this file's location as the project root)
- **GitHub repo:** `https://github.com/AnuragMittal-arch/Brandom-Agency` (branch `main`)
- **Live site:** `https://brandom.agency`
- **Hosting:** DigitalOcean droplet with aaPanel. CI/CD is already set up; pushing to `main` auto-deploys.
- **Owner:** Anurag (`AnuragMittal-arch` on GitHub). The user is added as a collaborator.

### Key files

- `index.html` — main page markup. Headline, taglines, links live here.
- `styles.css` — all styling (colors, fonts, layout).
- `Violetweb_compressed.mp4`, `violet-web.mp4` — background videos.
- `logos/` — brand logos.
- `.user.ini` — **do not touch** (server-managed by aaPanel).
- `.github/workflows/deploy.yml` — **do not edit** unless explicitly asked.

### First-time setup (only if the user is brand new)

Check whether git is already set up: run `git -C <project-root> remote -v`. If it returns the GitHub URL, skip to "Daily workflow" below.

If the folder isn't a git repo yet (no `.git` directory, or it's broken), walk the user through this **one time**:

1. **Install GitHub Desktop** (handles all auth, no terminals needed):
   - Tell the user: "Go to https://desktop.github.com, click the big Download button, open the file, drag the app into Applications."
   - Tell them to open GitHub Desktop and sign in with the GitHub account that received the collaborator invite.

2. **Accept the collaborator invite** if not already done:
   - "Check your email for a message from GitHub titled 'AnuragMittal-arch invited you...' Click Accept invitation."
   - Or visit `https://github.com/AnuragMittal-arch/Brandom-Agency/invitations`.

3. **Clone the repo via GitHub Desktop:**
   - Tell them: "In GitHub Desktop, click File → Clone repository. Pick Brandom-Agency. For Local Path, choose your Desktop. Click Clone."
   - Result: a folder `Brandom-Agency` appears on their Desktop, with a working `.git` inside.

4. **Reopen Claude pointing at the new folder** (`~/Desktop/Brandom-Agency`).

Once set up, the user never needs to touch GitHub Desktop again unless asked to "push" (see below).

### Daily workflow — when the user asks for a change

Listen for things like:

- "Change the headline to X"
- "Make the email say Y"
- "Swap the background video for the new file I just dropped here"
- "Replace the logo in the corner"
- "Make the page background pure black"

Steps:

1. **Make the edit** in the relevant file (`index.html` or `styles.css` most often). Use the Read tool to look at the current content first, then Edit.
2. **Confirm in plain English** what you changed ("Updated the headline to 'X'. The page background is now pure black.").
3. **Stage and commit** from bash:
   ```
   git -C <project-root> add -A
   git -C <project-root> commit -m "<short description of change>"
   ```
   These work without auth.
4. **Push.** The user's Mac has GitHub Desktop installed which caches credentials in macOS Keychain via `osxkeychain`. Try `git -C <project-root> push origin main` first.
   - If push fails with auth error, tell the user: "Open GitHub Desktop. You'll see your latest change at the top. Click the **Push origin** button. That sends it live."
   - GitHub Desktop will push using its cached credentials; no token needed from the user.
5. **Tell them what to expect:** "Your change will be live at https://brandom.agency in about 30 seconds. Refresh the page (hard refresh with Cmd+Shift+R) to see it."

### When the user says "push it live" / "deploy" / "make it live"

That's their signal that step 3 onward should happen. Don't push until they say so — that way they can preview text-only changes before they go public.

### If the user says "undo"

- "Undo the last change": run `git -C <project-root> revert HEAD --no-edit && git -C <project-root> push origin main`, then ask them to click Push in GitHub Desktop if push didn't work.
- Tell them: "Reverted. The previous version is being deployed."

### Things to refuse politely

- **Don't edit `.user.ini`** — it's locked on the server and will break deploys.
- **Don't edit `.github/workflows/deploy.yml`** unless explicitly told to change the CI pipeline.
- **Don't add files larger than 90 MB** — GitHub caps at 100 MB. If the user drops a big video, tell them: "That file is too big for GitHub. We can host it elsewhere (Vimeo embed, S3, etc.) — want me to do that instead?"
- **Don't force-push or rewrite history** on `main`.

### If the user breaks something visually and isn't sure what

Run `git -C <project-root> log --oneline -10` to find the last good commit, then `git revert <bad-commit-hash>`. Walk them through what changed.

### Verifying a deploy worked

After pushing, the workflow run is at `https://github.com/AnuragMittal-arch/Brandom-Agency/actions`. Green checkmark = deployed. Red X = failed; click into the run and read the error. The most common failure is the chown step on `.user.ini`, which the current workflow already handles. If something else fails, tell the user "the deploy hit a snag, I'll look into it" and read the log.

---

## Daily workflow — for Vito (plain English)

You don't need to read the technical part above. Just:

1. Open Claude on your Mac.
2. Make sure it has access to the `Brandom-Agency` folder on your Desktop.
3. Say what you want to change. Examples:
   - "Change the headline to 'Hi, I'm Violet — your AI brand partner.'"
   - "Use violetweb_v2.mp4 instead of the current background video. I just put it in the folder."
   - "Make the email link bigger."
4. When happy, say: **push it live**
5. If Claude tells you "open GitHub Desktop and click Push origin", do that. One click.
6. Wait ~30 seconds. Refresh `https://brandom.agency` (hold Shift while clicking the reload button) to see it.

If you ever want to undo, say: "undo the last change".
