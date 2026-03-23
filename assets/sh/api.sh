 
#!/usr/bin/env bash
set -e

echo "=== GitHub Pages Hard Bootstrap (Public/Private) ==="

read -p "GitHub username: " GH_USER
read -p "Repository name: " GH_REPO
# Added visibility prompt
read -p "Make repository private? (y/N): " PRIVATE_INPUT
read -s -p "GitHub Personal Access Token: " GH_TOKEN
echo

# Logic to determine boolean string for JSON
if [[ "$PRIVATE_INPUT" =~ ^[Yy]$ ]]; then
  IS_PRIVATE="true"
  echo ">> Setting mode: PRIVATE"
else
  IS_PRIVATE="false"
  echo ">> Setting mode: PUBLIC"
fi

API="https://api.github.com"
REPO_API="$API/repos/$GH_USER/$GH_REPO"

# ---- create repo if missing ----
# We inject $IS_PRIVATE into the JSON payload
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: token $GH_TOKEN" \
  "$REPO_API" | grep -q 200 || \
curl -s -X POST "$API/user/repos" \
  -H "Authorization: token $GH_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "{
    \"name\": \"$GH_REPO\",
    \"private\": $IS_PRIVATE,
    \"auto_init\": false
  }" >/dev/null

# ---- local setup ----
mkdir -p "$GH_REPO"
cd "$GH_REPO"

git init
git checkout -B ukhona

# ---- content ----
cat <<EOF > index.md
# GitHub Pages is live

Bootstrap successful.
Repo Visibility: $IS_PRIVATE
EOF

git add index.md
git commit -m "bootstrap gh-pages"

# ---- remote ----
git remote remove origin 2>/dev/null || true
git remote add origin "https://$GH_USER:$GH_TOKEN@github.com/$GH_USER/$GH_REPO.git"

# ---- FORCE ALIGN (intentional) ----
git push -f origin ukhona

# ---- enable Pages ----
# Note: GitHub Pages on Private repos requires a Pro account
curl -s -X POST "$REPO_API/pages" \
  -H "Authorization: token $GH_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d '{
    "source": { "branch": "ukhona", "path": "/" }
  }' >/dev/null || true

echo
echo "======================================"
echo "LIVE (may take ~30s):"
echo "https://$GH_USER.github.io/$GH_REPO/"
echo "======================================"