#!/bin/bash

set -euo pipefail

git config user.name "READMEbot"
git config user.email "readmebot@users.noreply.github.com"

initial_head=$(git rev-parse HEAD)
status=$(git status --short)

if [[ $status == *"README.md"* ]]
then
  git add README.md
  git commit -m "[auto] [ci skip] Generate README"
fi

if [[ $status == *"ARCHIVE.md"* ]]
then
  git add ARCHIVE.md
  git commit -m "[auto] [ci skip] Generate ARCHIVE"
fi

if [[ $status == *"APPSTORE.md"* ]]
then
  git add APPSTORE.md
  git commit -m "[auto] [ci skip] Generate APPSTORE"
fi

if [[ $status == *"LATEST.md"* ]]
then
  git add LATEST.md
  git commit -m "[auto] [ci skip] Generate LATEST"
fi

if [[ $(git rev-parse HEAD) != "$initial_head" ]]; then
  git push --quiet origin HEAD:master
fi
