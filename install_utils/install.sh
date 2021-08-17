#!/bin/bash
# ACTION: Install lsd, bat, mysql-client, rockyou.txt, python2, pip2, exploitdb.
# INFO: Install lsd, bat, mysql-client and create some aliases
# DEFAULT: y

# Config variables
base_dir="$(dirname "$(readlink -f "$0")")"

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Install packages
echo -e "\e[1mInstalling packages...\e[0m"
dpkg -i "${base_dir}/lsd_0.20.1_amd64.deb"
dpkg -i "${base_dir}/bat_0.18.2_amd64.deb"
dpkg -i "${base_dir}/mysql-apt-config_0.8.18-1_all.deb"
dpkg -i "${base_dir}/mysql-common_8.0.26-1debian10_amd64.deb"
apt-get update
apt install -y scrub mysql-client python2 exploitdb

wget -O /usr/bin/ipsweep https://raw.githubusercontent.com/xansx/ipsweep/main/ipsweep.sh
wget -O /usr/bin/whichSystem https://raw.githubusercontent.com/xansx/whichSystem/main/whichSystem.sh
chmod +x /usr/bin/ipsweep /usr/bin/whichSystem

gzip -d /usr/share/wordlists/rockyou.txt.gz

python2 "${base_dir}/get-pip.py"
python3 "${base_dir}/get-pip3.py"

# Config aliases for global (all users)
echo -e "\e[1mSetting configs to all users...\e[0m"
for d in  /etc/skel/  /home/*/ /root/; do
    [ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue	# Skip dirs that no are homes

	cat "${base_dir}/bash_aliases" >> "$d/.bash_aliases"

	git clone --depth 1 https://github.com/junegunn/fzf.git "$d/.fzf"
	echo ".fzf/install -all" >> "$d/pendiente.txt"

    chown -R $(stat "$d" -c %u:%g) "$d/.fzf/"

done

# Load .bash_aliases from root .bashrc
grep -q ".bash_aliases" /root/.bashrc || echo '
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
' >> /root/.bashrc
