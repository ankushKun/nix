#!/usr/bin/env bash
# Backup script to commit and push Nix configs to GitHub

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Checking for changes..."
if [[ -z $(git status -s) ]]; then
    echo "✅ No changes to backup"
    exit 0
fi

echo "📋 Current changes:"
git status -s

echo ""
echo "📝 Staging all changes..."
git add .

# Get commit message from argument or use default
if [ -n "$1" ]; then
    COMMIT_MSG="$1"
else
    COMMIT_MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
fi

echo "💾 Creating commit: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing to GitHub..."
git push origin main

echo "✅ Backup complete! Changes pushed to GitHub"
