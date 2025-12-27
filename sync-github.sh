#!/bin/bash

# APK Audit Tool - GitHub Sync Script

echo "🔄 Syncing APK Audit Tool to GitHub..."

# Add all changes
git add -A

# Check if there are changes to commit
if git diff-staged --quiet; then
    echo "✅ No changes to commit"
else
    # Commit with timestamp
    git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Pull with rebase
echo "📥 Pulling latest changes..."
git pull --rebase origin main 2>/dev/null || echo "No remote configured yet"

# Push
echo "📤 Pushing to GitHub..."
git push origin main 2>/dev/null || echo "No remote configured yet"

echo "✅ Sync complete!"
