#!/usr/bin/env bash
#|---/ /+------------------------------------------+---/ /|#
#|--/ /-| Script to install Arc Blueberry theme   |--/ /-|#
#|-/ /--| Based on omarchy arc-blueberry          |-/ /--|#
#|/ /---+------------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"

THEME_NAME="Arc Blueberry"
THEME_ARCHIVE="${scrDir}/../Source/arcs/Theme_Arc-Blueberry.tar.gz"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
THEME_DIR="${confDir}/hyde/themes/${THEME_NAME}"

print_log -g "[THEME] " -b "Installing :: " "${THEME_NAME}"

# Create theme directory
if [ ! -d "${THEME_DIR}" ]; then
    mkdir -p "${THEME_DIR}"
    print_log -g "[THEME] " -stat "created" "${THEME_DIR}"
fi

# Extract theme
if [ -f "${THEME_ARCHIVE}" ]; then
    tar -xzf "${THEME_ARCHIVE}" -C "${THEME_DIR}/.."
    print_log -g "[THEME] " -stat "extracted" "${THEME_NAME} theme"
    
    # Set sort order
    echo "13" > "${THEME_DIR}/.sort"
    
    print_log -g "[THEME] " -stat "installed" "${THEME_NAME}"
    print_log -y "[THEME] " -b "To apply: " "hyde theme select"
else
    print_log -r "[THEME] " -err "not found" "${THEME_ARCHIVE}"
    exit 1
fi
