#!/bin/bash
# Venant Blog - Disaster Recovery / Rebuild Script

set -e

REPO_URL="https://github.com/farizvect/venant-blog"
TARGET_DIR="$HOME/VENANT-BLOG"

echo "🐦 Starting Venant Blog environment rebuild..."

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
