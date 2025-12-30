#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG="$HOME/.local/share/aelyx/user/config.json"
QS_DIR="$HOME/.config/quickshell/ae-qs"
REPO="xZepyx/aelyx-shell"
API="https://api.github.com/repos/$REPO/releases/latest"

figlet "Updating"

# Check config exists
if [[ ! -f "$CONFIG" ]]; then
    echo "config.json not found"
    exit 1
fi

# Get current version
current="$(jq -r '.shellInfo.version // empty' "$CONFIG")"
if [[ -z "$current" ]]; then
    echo "version not found"
    exit 1
fi

# Get latest release version
latest_tag="$(curl -fsSL "$API" | jq -r '.name // .tag_name')"
if [[ -z "$latest_tag" ]]; then
    echo "failed to fetch latest version"
    exit 1
fi

latest="${latest_tag#v}"

if [[ "$current" == "$latest" ]]; then
    echo "already up to date ($current)"
    exit 0
fi

# Create temp dir and download zip
tmp="$(mktemp -d)"
zip="$tmp/aelyx-shell.zip"

curl -fL \
    "https://github.com/$REPO/releases/download/$latest_tag/aelyx-shell.zip" \
    -o "$zip"

# Extract zip
unzip -q "$zip" -d "$tmp"

SRC_DIR="$tmp/aelyx-shell/quickshell/ae-qs"

# Check if ae-qs exists in extracted folder
if [[ ! -d "$SRC_DIR" ]]; then
    echo "ae-qs folder not found in ZIP"
    exit 1
fi

# Remove old contents and ensure folder exists
rm -rf "$QS_DIR"/*
mkdir -p "$QS_DIR"

# Copy new contents
cp -r "$SRC_DIR/"* "$QS_DIR/"

# Update version in config.json
tmp_cfg="$(mktemp)"
jq --arg v "$latest" '.shellInfo.version = $v' "$CONFIG" > "$tmp_cfg"
mv "$tmp_cfg" "$CONFIG"
killall quickshell
quickshell -c ae-qs
echo "Updated $current -> $latest"
