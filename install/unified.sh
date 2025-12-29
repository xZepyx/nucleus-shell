#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BLUE="\033[34m"
RESET="\033[0m"

clear
echo -e "${BLUE}"
figlet "ae-qs"
echo -e "${RESET}"

bash "$ROOT_DIR/pkg.sh"
bash "$ROOT_DIR/dotfile.sh"
