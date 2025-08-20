#!/bin/bash

set -e

usage() {
  echo "Usage: $0 <start_commit> <end_commit> [--dry-run]"
  echo "Example: $0 abc123 def456 --dry-run"
  exit 1
}

if [ $# -lt 2 ]; then
  usage
fi

START_COMMIT=$1
END_COMMIT=$2
DRY_RUN=false

if [ "$3" == "--dry-run" ]; then
  DRY_RUN=true
fi

# Check git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: This is not a git repository."
  exit 1
fi

# Validate commits
if ! git cat-file -e "$START_COMMIT"^{commit} 2>/dev/null; then
  echo "Error: Start commit '$START_COMMIT' not found."
  exit 1
fi

if ! git cat-file -e "$END_COMMIT"^{commit} 2>/dev/null; then
  echo "Error: End commit '$END_COMMIT' not found."
  exit 1
fi

# Get changed files between commits
FILES=$(git diff --name-only "$START_COMMIT" "$END_COMMIT")

if [ -z "$FILES" ]; then
  echo "No changed files found between commits $START_COMMIT and $END_COMMIT."
  exit 0
fi

# Filter out excluded files and directories
FILTERED_FILES=$(echo "$FILES" | grep -vE '^public-old(/|$)|^\.vscode(/|$)|^\.cursor(/|$)|^changes\.sql$|^\.gitignore$')

if [ -z "$FILTERED_FILES" ]; then
  echo "No changed files remain after excluding specified patterns."
  exit 0
fi

echo "Files changed between $START_COMMIT and $END_COMMIT (excluding specified files/dirs):"
echo "$FILTERED_FILES"

if [ "$DRY_RUN" == true ]; then
  echo "[Dry-run] Would zip these files while preserving folder structure."
  exit 0
fi

ZIP_NAME="changes_${START_COMMIT}_to_${END_COMMIT}_$(date +%Y%m%d_%H%M%S).zip"

# Zip filtered files keeping folder structure
echo "$FILTERED_FILES" | zip -r "$ZIP_NAME" -@

echo "Created zip archive: $ZIP_NAME"