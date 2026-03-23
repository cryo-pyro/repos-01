#!/bin/bash

echo "--- GitHub Repo Privacy Updater ---"

# Prompt for inputs interactively
read -p "Enter your GitHub username: " USERNAME
read -p "Enter the repository name: " REPO_NAME

# Use -s to silently read the token (won't show on screen)
read -s -p "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
echo "" # Just prints a newline after the silent input

echo "Attempting to make $USERNAME/$REPO_NAME private..."

# The curl request
response=$(curl -s -w "%{http_code}" -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$USERNAME/$REPO_NAME \
  -d '{"private":true}')

# Extract the HTTP status code
http_code=$(tail -c4 <<< "$response")

# Error Handling
if [ "$http_code" -eq 200 ]; then
  echo "✅ Success! The repository is now private."
else
  echo "❌ Failed to change visibility. HTTP Status Code: $http_code"
  echo "Please check your token permissions and repository name."
fi