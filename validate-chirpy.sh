#!/bin/bash

# validate-chirpy.sh
# Checks for conflicting theme override folders when using jekyll-theme-chirpy as a Gem

THEME_DIRS=("_sass" "_includes" "_layouts" "assets/css")
BACKUP_DIR="chirpy_theme_backup_$(date +%Y%m%d%H%M%S)"
FOUND_CONFLICTS=0

echo "🔍 Validating Chirpy setup..."

# Check for 'theme: jekyll-theme-chirpy' in _config.yml
if grep -q '^theme:\s*jekyll-theme-chirpy' _config.yml; then
  echo "✅ Theme is set to jekyll-theme-chirpy (gem-based)"
else
  echo "⚠️  Theme is not set to jekyll-theme-chirpy. This script is only for Gem-based Chirpy."
  exit 1
fi

# Look for override folders
for dir in "${THEME_DIRS[@]}"; do
  if [ -e "$dir" ]; then
    echo "❌ Found override: $dir"
    FOUND_CONFLICTS=1
  fi
done

if [ "$FOUND_CONFLICTS" -eq 0 ]; then
  echo "✅ No conflicting override folders found. You're good to go!"
  exit 0
fi

echo "⚠️  The above folders may conflict with the gem-based Chirpy theme."
read -p "Do you want to move them to $BACKUP_DIR? (y/n): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  mkdir "$BACKUP_DIR"
  for dir in "${THEME_DIRS[@]}"; do
    if [ -e "$dir" ]; then
      mv "$dir" "$BACKUP_DIR/"
      echo "📦 Moved $dir to $BACKUP_DIR/"
    fi
  done
  echo "✅ Cleanup complete. You can rebuild your site now."
else
  echo "❌ No changes made. You should manually review the override folders."
fi
