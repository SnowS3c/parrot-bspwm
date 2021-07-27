#!/bin/bash
# ACTION: Install feh
# INFO: Install feh to load wallpapers
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }


# Install package
echo -e "\e[1mInstalling packages...\e[0m"
apt install -y feh

# Copy wallpaper
echo -e "\e[1mCopy wallpaper...\e[0m"
cp "${base_dir}/wallhaven-blue.jpg" /usr/share/backgrounds/
