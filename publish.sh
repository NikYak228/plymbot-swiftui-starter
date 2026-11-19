#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
command -v gh >/dev/null
command -v git >/dev/null
if ! gh api user --jq .login >/dev/null 2>&1; then
  gh auth login --hostname github.com --git-protocol https --web
fi
owner="$(gh api user --jq .login)"
repo="$owner/plymbot-swiftui-starter"
if [[ ! -d .git ]]; then
  git init -b main
fi
# Publish only the standalone starter files, never a parent repository.
[[ "$(git rev-parse --show-toplevel)" == "$PWD" ]]
git add .gitignore README.md LICENSE Plymbot Plymbot.xcodeproj .github publish.sh
if ! git diff --cached --quiet; then
  git -c user.name="$owner" -c user.email="$owner@users.noreply.github.com" commit -m "Add initial standalone Plymbot SwiftUI preview"
fi
if git remote get-url origin >/dev/null 2>&1; then
  echo "Origin already exists; stopping without changing an existing repository."
  exit 1
fi
gh repo create "$repo" --public --description "Initial SwiftUI interface prototype for Plymbot by Plyrum" --source . --remote origin
gh auth setup-git --hostname github.com
git push -u origin main
gh repo view "$repo" --json url,isPrivate --jq '{url: .url, public: (.isPrivate | not)}'
