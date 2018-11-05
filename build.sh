#!/usr/bin/env bash
set -e

###
# Check we're on master
echo "Checking branch..."
branch=$(git rev-parse --abbrev-ref HEAD | tr -d "\n")
if [ "$branch" != "master" ]; then
  echo >&2 "Must build from the master branch. You're currently on $branch"
  exit 1
fi

###
# Check for uncommitted changes
echo "Checking for clean working tree..."
if ! git diff-index --quiet HEAD --
then
  echo >&2 "Cannot build: your index contains uncommitted changes."
  git diff-index --name-status -r HEAD -- >&2
  exit 1
fi

###
# Infer new version
last_version=$(git tag | grep build- | tr -d 'build-' | sort -n | tail -n1)
version="build-$((last_version+1))"

git checkout build
git merge "$branch" -m "Merge $branch into build"

###
# install deps and build production assets
npm install && npm run build:prod

###
# Check for changes from webpack compilation
# if ! git diff-index --quiet HEAD --
change_count=$(git ls-files --exclude-standard --others | wc -l)
if (($change_count > 0)); then
  echo "Noticed the following changes as a result of the build:"
  git status
  ###
  # commit changes
  git add public config/initializers/fingerprint.rb
  git commit -m "Release $version"
else
  echo "No changes to assets in release $version"
fi

git tag $version
git push && git push --tags
git checkout $branch
echo $version
