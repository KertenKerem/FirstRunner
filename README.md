## Here I collect the scripts that automate the routine and boring tasks I do in every virtual server installation.
## This file using for base system configuration when TEST-Ubuntu server first.

"first_runner.sh"

*** Features: ***
- Set Hostname
- Set IP Address and name servers using /etc/netplan/00-installer-config.yaml
- Set Hosts file using /etc/hosts
- Set Swap on or off for docker installation
- Set SSH PasswordAuthentication yes or no
- Set SSH PermitRootLogin yes or no
- Set root password to "1"
- Install required base packages like wget, curl, unzip, htop, net-tools

"node_exporter_installer.sh"

*** Features: ***
- Node_exporter auto installer
- Download from github repo
- Extract and copy files
- Create nodeexporter user and group
- Create service file and enable service


"dhcpTOstaticIP.py"

*** Features: ***
- It converts your DHCP-assigned IP addresses into static IP addresses and saves them as /etc/netplan/01-netcfg.yaml.
- It also deletes the 50-cloud-init.yaml file if present.
