#!/bin/bash
# Hugo Blog - Disaster Recovery / Rebuild Script

set -e

# Ask owner for repo details if not configured
REPO_URL="<YOUR-REPO-URL>"
TARGET_DIR="$HOME/<BLOG-DIR>"

echo "Starting blog environment rebuild..."

# 1. Check Hugo
if ! command -v hugo &> /dev/null; then
    echo "Installing Hugo Extended..."
    sudo apt update && sudo apt install -y hugo
fi

# 2. Clone Repository
if [ ! -d "$TARGET_DIR" ]; then
    echo "Cloning templ branch..."
    git clone -b templ --recursive "$REPO_URL" "$TARGET_DIR"
else
    echo "Target directory exists. Pulling latest changes..."
    cd "$TARGET_DIR"
    git pull origin templ
    git submodule update --init --recursive
fi

# 3. Setup Git Credential Store
git config --global credential.helper store

echo "✅ Environment Ready at $TARGET_DIR"
echo "Note: Ensure your GitHub PAT is active and gh CLI is logged in."
