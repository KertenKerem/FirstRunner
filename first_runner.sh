#!/bin/bash

echo -e "INSTALLING REQUIRED PACKAGES ..."
apt update > /dev/null 2>&1 && apt install jq sed wget git unzip curl net-tools -y > /dev/null 2>&1

git clone -f https://github.com/KertenKerem/FirstRunner.git /tmp/first_runner > /dev/null 2>&1

if [ $? -eq 0 ]; then
   echo -e "\\nOK\\n"
   exit 0
else
   echo -e "\\nFAIL\\n"
   exit 1
fi

cd /tmp/FirstRunner

# Read the JSON file
content=$(jq '. < env.json')

# Extract properties
hostname=$(echo $content | jq -r '.hostname')
ipaddresses=$(echo $content | jq -r '.ipaddresses')
hosts=$(echo $content | jq -r '.hosts')

# Print the properties
echo -e "Hostname: $hostname"
echo -e "IP Addresses: $ipaddresses"
echo -e "Hosts: $hosts"

echo -e "SETTING IP ADDRESSES IN /etc/netplan/00-installer-config.yaml..."
cp /tmp/first_runner/teplates/00-installer-config.yaml /etc/netplan/
sed -i "s/ipaddresses: \[xxx.xxx.xxx.xxx\/xx\]/ipaddresses: $ip_address/" /etc/netplan/00-installer-config.yaml