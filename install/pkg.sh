#!/usr/bin/env bash
set -Eeuo pipefail

# UI
info() { printf "[*] %s\n" "$1"; }
ok()   { printf "[✓] %s\n" "$1"; }
fail() { printf "[✗] %s\n" "$1" >&2; exit 1; }

confirm() {
    read -rp "[?] $1 [y/N]: " yn
    [[ "$yn" =~ ^[Yy]$ ]]
}

exists() {
    command -v "$1" &>/dev/null
}

installed() {
    pacman -Qq "$1" &>/dev/null
}

run() {
    info "$1"
    shift
    "$@" &>/dev/null || fail "$1 failed"
    ok "$1"
}

# Distro check
[[ -f /etc/arch-release ]] || fail "Unsupported distro (Arch only)"

info "Detected Arch Linux"

confirm "Install dependencies?" || exit 0

# Git
exists git || run "Installing git" sudo pacman -S --needed --noconfirm git

# AUR helper selection
echo "Select AUR helper:"
echo "1. yay"
echo "2. paru"
read -rp "[?] Choice: " choice

case "$choice" in
    1) helper="yay" ;;
    2) helper="paru" ;;
    *) fail "Invalid choice" ;;
esac

# Install helper if missing
if ! exists "$helper"; then
    confirm "Install $helper?" || fail "$helper is required"
    run "Installing base-devel" sudo pacman -S --needed --noconfirm base-devel
    tmp="$(mktemp -d)"

    run "Cloning $helper" \
        git clone "https://aur.archlinux.org/$helper.git" "$tmp/$helper"

    run "Building $helper" \
        bash -c "cd '$tmp/$helper' && makepkg -si --noconfirm"

    rm -rf "$tmp"
fi

installer="$helper -S --needed --noconfirm"

# Packages
packages=(
    hyprland hyprpaper hyprlock hyprpicker
    wf-recorder wl-clipboard grim slurp
    qt6ct qt5ct kvantum kvantum-qt5
    kitty fish starship
    firefox nautilus
    wl-color-picker imagemagick qt6-svg
    networkmanager wireplumber bluez-utils
    fastfetch playerctl brightnessctl
    papirus-icon-theme-git hyprsunset
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
    quickshell-git matugen-bin
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    xdg-desktop-portal-hyprland
    zenity jq ddcutil flatpak
)

# Install loop
for pkg in "${packages[@]}"; do
    if installed "$pkg"; then
        info "$pkg already installed"
    else
        run "Installing $pkg" $installer "$pkg"
    fi
done

ok "Done"

