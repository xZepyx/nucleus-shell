#!/usr/bin/env bash
set -Eeuo pipefail

RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
GRAY="\033[90m"
RESET="\033[0m"

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

exists() {
    command -v "$1" &>/dev/null
}

installed() {
    if [[ "$DISTRO" == "arch" ]]; then
        pacman -Qq "$1" &>/dev/null
    elif [[ "$DISTRO" == "fedora" ]]; then
        rpm -q "$1" &>/dev/null
    fi
}

# Detect distro
if [[ -f /etc/fedora-release ]]; then
    DISTRO="fedora"
elif [[ -f /etc/arch-release ]]; then
    DISTRO="arch"
else
    echo -e "${RED}Unsupported distro${RESET}"
    exit 1
fi

echo -e "${BLUE}Detected distro: $DISTRO${RESET}"

if ! confirm "install dependencies?"; then
    exit 0
fi

# Core tools
if ! exists git; then
    if [[ "$DISTRO" == "arch" ]]; then
        run_cmd "sudo pacman -S --needed git"
    else
        run_cmd "sudo dnf install -y git"
    fi
fi

# Fedora does not need yay; Arch installs yay
if [[ "$DISTRO" == "arch" ]]; then
    if ! exists yay; then
        confirm "install yay?" && {
            run_cmd "sudo pacman -S --needed base-devel"
            tmp=$(mktemp -d)
            run_cmd "git clone https://aur.archlinux.org/yay.git $tmp/yay"
            run_cmd "cd $tmp/yay && makepkg -si"
            rm -rf "$tmp"
        }
    fi
fi

# Packages
if [[ "$DISTRO" == "arch" ]]; then
    packages=(
        hyprland hyprpaper hyprlock hyprpicker
        wf-recorder wl-clipboard grim slurp kvantum-qt5
	qt6ct qt5ct kvantum
        kitty fish starship
        firefox nautilus
        wl-color-picker imagemagic
        networkmanager wireplumber bluez-utils
        fastfetch playerctl brightnessctl
        papirus-icon-theme-git hyprsunset
        nerd-fonts ttf-jetbrains-mono
        ttf-fira-code ttf-firacode-nerd
        ttf-material-symbols-variable-git
        ttf-font-awesome ttf-fira-sans
        quickshell matugen-bin
        qt5-wayland qt6-wayland qt5-graphicaleffects qt6-5compat
        xdg-desktop-portal-hyprland
        zenity jq ddcutil flatpak
    )
    installer="yay -S --noconfirm"
else
    packages=(
        hyprland hyprpaper hyprlock hyprpicker
        wf-recorder grim slurp
        kitty fish starship kvantum-qt5
	qt5ct qt6ct kvantum
        firefox nautilus wl-clipboard
        NetworkManager wireplumber bluez
        fastfetch playerctl brightnessctl
        papirus-icon-theme hyprsunset
        'NerdFonts-*' jetbrains-mono-fonts
        fira-code-font fira-code-nerd-font
        material-symbols-font awesome-fonts fira-sans-fonts
        qt5-qtwayland qt6-qtwayland qt5-qtgraphicaleffects
        xdg-desktop-portal-hyprland
        zenity jq ddcutil flatpak
    )
    installer="sudo dnf install -y"
fi

for pkg in "${packages[@]}"; do
    if installed "$pkg"; then
        echo -e "${GRAY}$pkg already installed${RESET}"
    else
        run_cmd "$installer $pkg"
    fi
done

echo -e "${GREEN}done${RESET}"
