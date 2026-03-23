#!/bin/bash
# ~/config/quickshell/scripts/background/gencolors.sh
# Generate Matugen color scheme for a given wallpaper

USER_WIDE=false

# Parse flags
while [[ "$1" == --* ]]; do
    case "$1" in
        --user-wide)
            USER_WIDE=true
            shift
            ;;
        *)
            echo "Unknown flag: $1" >&2
            exit 1
            ;;
    esac
done

WALLPAPER_PATH="$1"
SCHEME_TYPE="$2"
SCHEME_MODE="$3"
CONFIG_PATH="$4"

# Validate required arguments
if [[ -z "$WALLPAPER_PATH" || "$WALLPAPER_PATH" == "null" ]]; then
    echo "Error: no wallpaper provided" >&2
    exit 1
fi

: "${SCHEME_TYPE:?Error: scheme type not provided}"
: "${SCHEME_MODE:?Error: scheme mode not provided}"

# Strip file:// prefix if present
if [[ "$WALLPAPER_PATH" == file://* ]]; then
    WALLPAPER_PATH="${WALLPAPER_PATH#file://}"
fi

if ! $USER_WIDE; then
    if [[ -z "$CONFIG_PATH" || ! -f "$CONFIG_PATH" ]]; then
        echo "Error: config file not found: $CONFIG_PATH" >&2
        exit 1
    fi
fi


run_with_config() {
    matugen --config "$CONFIG_PATH" \
        image "$WALLPAPER_PATH" \
        --type "$SCHEME_TYPE" \
        --mode "$SCHEME_MODE" --prefer saturation
}

run_without_config() {
    matugen image "$WALLPAPER_PATH" \
        --type "$SCHEME_TYPE" \
        --mode "$SCHEME_MODE" --prefer saturation
}

if $USER_WIDE; then
    run_with_config
    run_without_config
else
    run_with_config
fi
