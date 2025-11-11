#!/usr/bin/env bash
# Restore script to pull and apply latest Nix configs from GitHub

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Checking for local changes..."
if [[ -n $(git status -s) ]]; then
    echo "⚠️  Warning: You have uncommitted changes!"
    git status -s
    echo ""
    read -p "Do you want to stash these changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Stashing local changes..."
        git stash push -m "Auto-stash before restore $(date '+%Y-%m-%d %H:%M:%S')"
    else
        echo "❌ Aborting restore to prevent data loss"
        exit 1
    fi
fi

echo "⬇️  Pulling latest changes from GitHub..."
git pull origin main

echo "🔨 Rebuilding Nix configuration..."
if command -v darwin-rebuild &> /dev/null; then
    darwin-rebuild switch --flake .
elif command -v home-manager &> /dev/null; then
    home-manager switch --flake .
else
    echo "⚠️  Neither darwin-rebuild nor home-manager found"
    echo "Please rebuild manually with:"
    echo "  darwin-rebuild switch --flake ~/.config/nix"
    echo "  OR"
    echo "  home-manager switch --flake ~/.config/nix"
fi

echo "✅ Restore complete! Configuration updated from GitHub"
