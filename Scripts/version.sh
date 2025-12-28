#!/usr/bin/env bash

TONYLANDDE_CLONE_PATH=$(git rev-parse --show-toplevel)
TONYLANDDE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
TONYLANDDE_REMOTE=$(git config --get remote.origin.url)
TONYLANDDE_VERSION=$(git describe --tags --always)
TONYLANDDE_COMMIT_HASH=$(git rev-parse HEAD)
TONYLANDDE_VERSION_COMMIT_MSG=$(git log -1 --pretty=%B)
TONYLANDDE_VERSION_LAST_CHECKED=$(date +%Y-%m-%d\ %H:%M%S\ %z)

generate_release_notes() {
  local latest_tag
  local commits

  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

  if [[ -z "$latest_tag" ]]; then
    echo "No release tags found"
    return
  fi

  echo "=== Changes since $latest_tag ==="

  commits=$(git log --oneline --pretty=format:"• %s" "$latest_tag"..HEAD 2>/dev/null)

  if [[ -z "$commits" ]]; then
    echo "No commits since last release"
    return
  fi

  echo "$commits"
}

# TONYLANDDE_RELEASE_NOTES=$(generate_release_notes)

echo "TonylandDE $TONYLANDDE_VERSION built from branch $TONYLANDDE_BRANCH at commit ${TONYLANDDE_COMMIT_HASH:0:12} ($TONYLANDDE_VERSION_COMMIT_MSG)"
echo "Date: $TONYLANDDE_VERSION_LAST_CHECKED"
echo "Repository: $TONYLANDDE_CLONE_PATH"
echo "Remote: $TONYLANDDE_REMOTE"
echo ""

if [[ "$1" == "--cache" ]]; then
  state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/tonylandde"
  mkdir -p "$state_dir"
  version_file="$state_dir/version"

  cat >"$version_file" <<EOL
TONYLANDDE_CLONE_PATH='$TONYLANDDE_CLONE_PATH'
TONYLANDDE_BRANCH='$TONYLANDDE_BRANCH'
TONYLANDDE_REMOTE='$TONYLANDDE_REMOTE'
TONYLANDDE_VERSION='$TONYLANDDE_VERSION'
TONYLANDDE_VERSION_LAST_CHECKED='$TONYLANDDE_VERSION_LAST_CHECKED'
TONYLANDDE_VERSION_COMMIT_MSG='$TONYLANDDE_VERSION_COMMIT_MSG'
TONYLANDDE_COMMIT_HASH='$TONYLANDDE_COMMIT_HASH'
EOL
# TONYLANDDE_RELEASE_NOTES='$TONYLANDDE_RELEASE_NOTES'

  echo -e "Version cache output to $version_file\n"

elif [[ "$1" == "--release-notes" ]]; then
  echo "$TONYLANDDE_RELEASE_NOTES"

fi
