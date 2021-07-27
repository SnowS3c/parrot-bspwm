#!/bin/bash
# ACTION: Install Firefox and firejail
# INFO: Install Firefox and firejail to launch Firefox
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }


# Install package
echo -e "\e[1mInstalling packages...\e[0m"
tar xjf "${base_dir}/firefox-90.0.2.tar.bz2"
apt install -y firejail

echo "Instalar addons FoxyProxy y wappalyzer en Firefox" >> /home/xansx/pendiente.txt
