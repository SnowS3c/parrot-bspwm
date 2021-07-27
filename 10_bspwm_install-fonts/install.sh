#!/bin/bash
# ACTION: Install Hack Nerd fonts
# INFO: Popular font Hack Nerd.
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Hack Nerd Fonts
echo -e "\e[1mInstalling Hack Nerd Fonts...\e[0m"
[ ! -d /usr/local/share/fonts ] && mkdir /usr/local/share/fonts/
unzip "$base_dir"/Hack.zip -d /usr/local/share/fonts
fc-cache -v
