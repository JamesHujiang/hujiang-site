#!/bin/bash
set -euo pipefail

DRAFTS=~/Documents/Jodex/50_Expression/Drafts
POSTS=~/Sites/hujiang/content/posts

# Sync all non-draft posts from Obsidian → Hugo
# Copies any .md file where draft: false (or draft is absent)
for f in "$DRAFTS"/*.md; do
  filename=$(basename "$f")
  if grep -q "^draft: false" "$f" 2>/dev/null || ! grep -q "^draft:" "$f" 2>/dev/null; then
    cp "$f" "$POSTS/$filename"
    echo "✓ Staged: $filename"
  fi
done

cd ~/Sites/hujiang
git add .
git diff --cached --quiet && echo "Nothing new to publish." && exit 0
git commit -m "publish: $(date '+%Y-%m-%d')"
git push
echo "✅ Published. Live in ~60s at https://hujiang.link"
