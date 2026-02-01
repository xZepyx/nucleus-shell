#!/usr/bin/env bash
set -euo pipefail

# Config

INSTALL_DIR="$HOME/.config/nucleus-shell/plugins"
CACHE_BASE="/tmp/nucleus-plugins"

declare -A PLUGIN_REPOS=(
  [official]="https://github.com/xZepyx/nucleus-plugins.git"
)

# Dependencies

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1"
    exit 1
  }
}

require git
require jq

mkdir -p "$INSTALL_DIR" "$CACHE_BASE"

# Repo handling

update_repo() {
  local name="$1"
  local url="$2"
  local dir="$CACHE_BASE/$name"

  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" pull --quiet
  else
    rm -rf "$dir"
    git clone --quiet "$url" "$dir"
  fi
}

update_all_repos() {
  for name in "${!PLUGIN_REPOS[@]}"; do
    update_repo "$name" "${PLUGIN_REPOS[$name]}"
  done
}

# Plugin Lookup

find_plugin() {
  local plugin="$1"

  for repo in "${!PLUGIN_REPOS[@]}"; do
    local path="$CACHE_BASE/$repo/$plugin"
    if [[ -d "$path" && -f "$path/manifest.json" ]]; then
      echo "$repo:$path"
      return 0
    fi
  done

  return 1
}

# Fetch

fetch_all() {
  update_all_repos

  for repo in "${!PLUGIN_REPOS[@]}"; do
    local base="$CACHE_BASE/$repo"

    for dir in "$base"/*/; do
      [[ -f "$dir/manifest.json" ]] || continue

      jq -r '
        "id: \(.id)
name: \(.name)
version: \(.version)
author: \(.author)
description: \(.description)
requires_nucleus: \(.requires_nucleus // "none")
repo: '"$repo"'
---"
      ' "$dir/manifest.json"
    done
  done
}

fetch_one() {
  local plugin="$1"
  update_all_repos

  local result
  result=$(find_plugin "$plugin") || {
    echo "Plugin '$plugin' not found in any repo"
    exit 1
  }

  local repo="${result%%:*}"
  local path="${result#*:}"

  jq -r '
    "id: \(.id)
name: \(.name)
version: \(.version)
author: \(.author)
description: \(.description)
requires_nucleus: \(.requires_nucleus // "none")
repo: '"$repo"'
---"
  ' "$path/manifest.json"
}

# Install / Update / Uninstall

install_plugin() {
  local plugin="$1"
  update_all_repos

  local dst="$INSTALL_DIR/$plugin"
  [[ -d "$dst" ]] && {
    echo "Plugin '$plugin' already installed"
    exit 0
  }

  local result
  result=$(find_plugin "$plugin") || {
    echo "Plugin '$plugin' not found"
    exit 1
  }

  local path="${result#*:}"
  cp -r "$path" "$dst"

  echo "Installed plugin '$plugin'"
}

uninstall_plugin() {
  local plugin="$1"
  local dst="$INSTALL_DIR/$plugin"

  [[ -d "$dst" ]] || {
    echo "Plugin '$plugin' is not installed"
    exit 0
  }

  rm -rf "$dst"
  echo "Uninstalled plugin '$plugin'"
}

fetch_all_machine() { # For quickshell
  update_all_repos

  for repo in "${!PLUGIN_REPOS[@]}"; do
    local base="$CACHE_BASE/$repo"

    for dir in "$base"/*/; do
      [[ -f "$dir/manifest.json" ]] || continue

      jq -r '
        [
          .id,
          .name,
          .version,
          .author,
          .description,
          (.requires_nucleus // "none"),
          "'"$repo"'"
        ] | @tsv
      ' "$dir/manifest.json"
    done
  done
}


update_plugin() {
  local plugin="$1"
  update_all_repos

  local dst="$INSTALL_DIR/$plugin"
  [[ -d "$dst" ]] || {
    echo "Plugin '$plugin' not installed"
    exit 1
  }

  local result
  result=$(find_plugin "$plugin") || {
    echo "Plugin '$plugin' not found in repos"
    exit 1
  }

  local src="${result#*:}"

  local local_version repo_version
  local_version=$(jq -r '.version' "$dst/manifest.json")
  repo_version=$(jq -r '.version' "$src/manifest.json")

  if [[ "$local_version" == "$repo_version" ]]; then
    echo "Plugin '$plugin' already up to date ($local_version)"
    exit 0
  fi

  rm -rf "$dst"
  cp -r "$src" "$dst"

  echo "Updated '$plugin' $local_version → $repo_version"
}

# CLI

usage() {
  cat <<EOF
Usage:
  plugins fetch all
  plugins fetch <pluginId>
  plugins install <pluginId>
  plugins uninstall <pluginId>
  plugins update <pluginId>
EOF
}

case "${1:-}" in
  fetch)
    [[ "${2:-}" == "all-machine" ]] && fetch_all_machine \
    || [[ "${2:-}" == "all" ]] && fetch_all \
    || fetch_one "${2:-}"
    ;;
  install)
    install_plugin "${2:-}"
    ;;
  uninstall)
    uninstall_plugin "${2:-}"
    ;;
  update)
    update_plugin "${2:-}"
    ;;
  *)
    usage
    ;;
esac
