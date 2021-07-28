#!/bin/bash
# ACTION: Install bspwm and essential tools and configs
# INFO: bspwm is a lightweight window manager, but needs some additional tools and configs for make it usable
# DEFAULT: y


# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Install packages
echo -e "\e[1mInstalling packages...\e[0m"
[ "$(find /var/cache/apt/pkgcache.bin -mtime 0 2>/dev/null)" ] || apt-get update
apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

# Downloading config from github
cd /tmp/
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install

apt install -y bspwm


# Copy users config
echo -e "\e[1mSetting configs to all users...\e[0m"
for d in /etc/skel /home/*/ /root; do
    [ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue	# Skip dirs that no are homes

    # Create config folder if no exists
    [ ! -d "$d/.config" ] && mkdir -v "$d/.config" && chown -R $(stat "$(dirname "$d")" -c %u:%g) "$d/.config"

    mkdir -p $d/.config/{bspwm,sxhkd} && chown -R $(stat "$d" -c %u:%g) $d/.config/{bspwm,sxhkd}

	cp -v "${base_dir}/bspwmrc" "$d/.config/bspwm/bspwmrc" && chown -R $(stat "$d" -c %u:%g) "$d/.config/bspwm/bspwmrc"
	chmod u+x "$d/.config/bspwm/bspwmrc"

    cp -v "${base_dir}/sxhkdrc" "$d/.config/sxhkd" && chown -R $(stat "$d" -c %u:%g) "$d/.config/sxhkd/sxhkdrc"

	sed -i "s/username/$(basename $d)/" "$d/.config/sxhkd/sxhkdrc"

    mkdir "$d/.config/bspwm/scripts" && chown -R $(stat "$d" -c %u:%g) "$d/.config/bspwm/scripts"
    cp -v "${base_dir}/bspwm_resize" "$d/.config/bspwm/scripts"
    chown -R $(stat "$d" -c %u:%g) "$d/.config/bspwm/scripts/bspwm_resize"
    chmod +x "$d/.config/bspwm/scripts/bspwm_resize"


done
