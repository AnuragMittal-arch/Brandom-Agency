#!/bin/bash
# Run once. Double-click this file in Finder to set up a clean git repo.
# This removes the broken .git directory (created by the sandbox earlier)
# and replaces it with a fresh clone of github.com/AnuragMittal-arch/Brandom-Agency.

set -e
cd "$(dirname "$0")"

echo "==> Cleaning broken .git directory"
sudo rm -rf .git

echo "==> Initializing fresh git repo pointing at GitHub"
git init -b main
git remote add origin https://github.com/AnuragMittal-arch/Brandom-Agency.git
git fetch origin
git reset --hard origin/main

echo "==> Caching credentials in macOS Keychain"
git config credential.helper osxkeychain

echo ""
echo "All done. You can now close this window."
echo "From here on, just ask Claude: \"change X on the site and push it.\""
read -p "Press Enter to close..."
