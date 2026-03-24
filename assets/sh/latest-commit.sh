#!/bin/bash
# latest-commit.sh — latest commit info + Pages deployment

read -p "GitHub username/org: " USER
read -p "Repository name: " REPO
read -p "Branch name (e.g., ukhona): " BRANCH
read -s -p "GitHub token (leave blank for public repo): " TOKEN
echo ""

AUTH_HEADER=""
if [ -n "$TOKEN" ]; then
    AUTH_HEADER="Authorization: token $TOKEN"
fi

# 1️⃣ Latest commit info on branch (SHA + timestamp)
LATEST=$(curl -s -H "$AUTH_HEADER" \
  "https://api.github.com/repos/$USER/$REPO/commits/$BRANCH" \
  | jq -r '.sha + " committed at " + .commit.committer.date')

if [ -z "$LATEST" ] || [ "$LATEST" == "null" ]; then
    echo "❌ Error fetching latest commit info. Check repo/branch or token."
    exit 1
fi

echo "✅ Latest commit on $BRANCH: $LATEST"

# 2️⃣ Latest successful Pages build
SUCCESSFUL_BUILD=$(curl -s -H "$AUTH_HEADER" \
  "https://api.github.com/repos/$USER/$REPO/pages/builds" \
  | jq -r '.[] | select(.status=="built") | "\(.commit) built at \(.updated_at)"' | head -n1)

if [ -z "$SUCCESSFUL_BUILD" ]; then
    echo "⚠️ No successful Pages build found yet."
else
    echo "🌐 Latest successful Pages commit: $SUCCESSFUL_BUILD"
fi