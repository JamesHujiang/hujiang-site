#!/bin/bash
set -euo pipefail

DRAFTS=~/Documents/Jodex/50_Expression/Drafts
POSTS=~/Sites/hujiang/content/posts

# Sync published posts (draft: false) into content/posts
for f in "$DRAFTS"/*.md; do
  filename=$(basename "$f")
  if grep -q "^draft: false" "$f" 2>/dev/null; then
    cp "$f" "$POSTS/$filename"
    echo "✓ Staged: $filename"
  else
    # If it exists in posts but is now draft: true or removed, delete it
    if [[ -f "$POSTS/$filename" ]]; then
      rm "$POSTS/$filename"
      echo "✗ Removed: $filename"
    fi
  fi
done

cd ~/Sites/hujiang
git add .
git diff --cached --quiet && echo "Nothing to publish." && exit 0
git commit -m "publish: $(date '+%Y-%m-%d')"
git push
echo "✅ Done. Live in ~60s at https://hujiang.link"
