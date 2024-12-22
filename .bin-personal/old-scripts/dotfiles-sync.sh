#!/bin/bash

REPO_DIR="$HOME/dotfiles"
COMMIT_MESSAGE="Automated commit on $(date +'%Y-%m-%d %H:%M:%S')"

cd "$REPO_DIR" || { echo "Directory $REPO_DIR not found."; exit 1; }

git add -A
git commit -m "$COMMIT_MESSAGE"
git push origin main
