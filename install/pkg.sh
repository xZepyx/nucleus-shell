#!/usr/bin/env bash
set -Eeuo pipefail

# UI
info() { printf "[*] %s\n" "$1"; }
ok()   { printf "[✓] %s\n" "$1"; }
fail() { printf "[✗] %s\n" "$1" >&2; exit 1; }

confirm() {
    local ans
    read -rp "[?] $1 [y/N]: " ans
    [[ "$ans" =~ ^[Yy]$ ]]
}

exists() {
    command -v "$1" &>/dev/null
}

installed() {
    pacman -Qi "$1" &>/dev/null
}

run() {
    local desc="$1"; shift
    info "$desc"
    "$@" &>/dev/null
    ok "$desc"
}

# Distro check
[[ -f /etc/arch-release ]] || fail "Arch Linux required"

info "Arch Linux detected"

confirm "Install dependencies?" || exit 0

# Ensure git
if ! exists git; then
    run "Installing git" sudo pacman -S --needed --noconfirm git
fi

# -----------------------------
# AUR helper detection
# -----------------------------
detect_helper() {
    if exists yay; then
        echo yay
        return
    fi

    if exists paru; then
        echo paru
        return
    fi

    echo ""
}

helper="$(detect_helper)"

# If helper already exists
if [[ -n "$helper" ]]; then
    ok "Detected AUR helper: $helper"
else
    info "No AUR helper detected"

    echo
    echo "Select AUR helper"
    echo "1) yay"
    echo "2) paru"
    read -rp "[?] Choice: " choice

    case "$choice" in
        1) helper="yay" ;;
        2) helper="paru" ;;
        *) fail "Invalid selection" ;;
    esac

    confirm "Install $helper?" || fail "$helper required"

    run "Installing build dependencies" \
        sudo pacman -S --needed --noconfirm base-devel

    tmpdir="$(mktemp -d)"

    run "Cloning $helper" \
        git clone "https://aur.archlinux.org/${helper}.git" "$tmpdir/$helper"

    run "Building $helper" \
        bash -c "cd '$tmpdir/$helper' && makepkg -si --noconfirm"

    rm -rf "$tmpdir"
fi

installer="$helper -S --needed --noconfirm"

# Packages
packages=(
    hyprland hyprpaper hyprlock hyprpicker
    wf-recorder wl-clipboard grim slurp
    qt6ct qt5ct kvantum kvantum-qt5
    kitty fish starship
    firefox nautilus network-manager-applet
    wl-color-picker imagemagick qt6-svg
    networkmanager wireplumber bluez-utils
    fastfetch playerctl brightnessctl
    papirus-icon-theme-git hyprsunset
    nerd-fonts ttf-jetbrains-mono
    ttf-fira-code ttf-firacode-nerd
    ttf-material-symbols-variable-git
    ttf-font-awesome ttf-fira-sans
    quickshell-git matugen-bin ffmpeg
    qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
    xdg-desktop-portal-hyprland
    zenity jq ddcutil flatpak nucleus-shell
)

info "Checking packages"

missing=()

for pkg in "${packages[@]}"; do
    if installed "$pkg"; then
        info "$pkg already installed"
    else
        missing+=("$pkg")
    fi
done

if (( ${#missing[@]} > 0 )); then
    run "Installing packages" $installer "${missing[@]}"
else
    info "All packages already installed"
fi

ok "Setup complete"
