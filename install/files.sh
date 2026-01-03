#!/usr/bin/env bash
set -Eeuo pipefail

RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
GRAY="\033[90m"
RESET="\033[0m"

ROOT_DIR="../"
SYSTEM_DIR="$ROOT_DIR/system"

confirm() {
    read -rp "$1 [y/N]: " yn
    [[ "$yn" =~ ^[Yy]$ ]]
}

run_cmd() {
    local cmd="$1"
    echo -e "${BLUE}>> $cmd${RESET}"

    if ! bash -c "$cmd"; then
        echo -e "${RED}command failed${RESET}"
        echo "1) retry"
        echo "2) skip"
        echo "3) exit"
        read -rp "> " c
        case "${c:-1}" in
            1) run_cmd "$cmd" ;;
            2) echo -e "${GRAY}skipped${RESET}" ;;
            3) exit 1 ;;
        esac
    fi
}

mkdir -p ~/.config ~/.local/share/aelyx

echo "select what to copy"

copy_all=false
copy_shell=false

confirm "copy all dotfiles?" && copy_all=true

if ! $copy_all; then
    confirm "copy shell configs (quickshell, matugen)?" && copy_shell=true
    confirm "copy themes/icons/fonts configs?" && copy_themes=true
fi

if $copy_all; then
    run_cmd "cp -r \"$SYSTEM_DIR/.config/\"* ~/.config/"
    run_cmd "cp -r \"$ROOT_DIR/quickshell\" ~/.config/"
else
    if $copy_shell; then
        run_cmd "cp -r \"$ROOT_DIR/quickshell\" ~/.config/"
        run_cmd "cp -r \"$SYSTEM_DIR/.config/matugen\" ~/.config/"
    fi
fi

echo -e "${GREEN}done${RESET}"
