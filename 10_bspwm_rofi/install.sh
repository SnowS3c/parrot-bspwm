#!/bin/bash
# ACTION: Install Rofi
# INFO: Rofi
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Install packages
echo -e "\e[1mInstalling packages...\e[0m"
[ "$(find /var/cache/apt/pkgcache.bin -mtime 0 2>/dev/null)" ] || apt-get update
apt install -y rofi

for d in /etc/skel/ /home/*/ /root/; do
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue  # Skip dirs that no are homes 

	cp -vr "${base_dir}/rofi" "$d/.config/" && chown -R $(stat "$d" -c %u:%g) "$d/.config/rofi"
done
