#!/bin/bash
# ACTION: Install lsd and bat.
# INFO: Install lsd and bat, and create some aliases
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Install tmux
echo -e "\e[1mInstalling packages...\e[0m"
dpkg -i "${base_dir}/lsd_0.20.1_amd64.deb"
dpkg -i "${base_dir}/bat_0.18.2_amd64.deb"
apt install -y scrub
wget -O /usr/bin/ipsweep https://raw.githubusercontent.com/xansx/ipsweep/main/ipsweep.sh
wget -O /usr/bin/whichSystem https://raw.githubusercontent.com/xansx/whichSystem/main/whichSystem.sh

cp -v "$base_dir/clearTarget" "$base_dir/setTarget" /usr/bin/
chmod +x /usr/bin/clearTarget /usr/bin/setTarget

# Config aliases for global (all users)
echo -e "\e[1mSetting configs to all users...\e[0m"
for d in  /etc/skel/  /home/*/ /root/; do
    [ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue	# Skip dirs that no are homes

	cat "${base_dir}/bash_aliases" >> "$d/.bash_aliases"

	git clone --depth 1 https://github.com/junegunn/fzf.git "$d/.fzf"
	echo ".fzf/install -all" >> "$d/pendiente.txt"

    chown -R $(stat "$(dirname "$d")" -c %u:%g) "$d/.fzf/"

done

# Load .bash_aliases from root .bashrc
grep -q ".bash_aliases" /root/.bashrc || echo '
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
' >> /root/.bashrc
