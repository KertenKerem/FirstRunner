#!/bin/bash

echo -e "INSTALLING REQUIRED PACKAGES ..."
apt update && apt install jq sed wget git unzip curl net-tools -y

git clone  https://github.com/Techiepi/RaspberryPi_Cam.git /tmp/first_runner

if [ $? -eq 0 ]; then
   echo -e "\\nOK\\n"
   exit 0
else
   echo -e "\\nFAIL\\n"
   exit 1
fi

# Read the JSON file
content=$(jq '. < env.json')

# Extract properties
hostname=$(echo $content | jq -r '.hostname')
ipaddress=$(echo $content | jq -r '.ipaddress')
hosts=$(echo $content | jq -r '.hosts')

# Print the properties
echo -e "Hostname: $hostname"
echo -e "IP Address: $ipaddress"
echo -e "Hosts: $hosts"

echo -e "SETTING IP ADDRESSES IN /etc/netplan/00-installer-config.yaml..."
sed -i "s/ipaddresses: \[xxx.xxx.xxx.xxx\/xx\]/ipaddresses: $ip_address/" /etc/netplan/01-netcfg.yaml