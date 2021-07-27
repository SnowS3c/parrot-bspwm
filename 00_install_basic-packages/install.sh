#!/bin/bash
# ACTION: Upgrade system packages
# INFO: Upgrade the system
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && { echo "Must run as root" 1>&2; exit 1; }

# Install free packages
echo -e "\e[1mUpdating packages...\e[0m"
apt update
parrot-upgrade -y

# Nmap --min-rate problem fix
service opensnitch stop
systemctl disable opensnitch

for d in /etc/skel/ /home/*/ /root/; do
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue  # Skip dirs that no are homes 

	echo -e "\n#Fix the Java Problem\nexport _JAVA_AWT_WM_NONREPARENTING=1\n" >> "$d/.bashrc"
done
